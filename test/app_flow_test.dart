import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petcare/main.dart';
import 'package:petcare/view/guide_pages.dart';

Future<void> openApp(
  WidgetTester tester, {
  double width = 360,
  double scale = 1,
}) async {
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  rootBundle.clear();
  await tester.pumpWidget(const PetCareApp());
  await tester.runAsync(() async {
    await rootBundle.loadString('assets/data/guides.json');
  });
  await tester.pumpAndSettle();
}

Finder verticalScroll() => find.byWidgetPredicate(
  (widget) =>
      widget is Scrollable && widget.axisDirection == AxisDirection.down,
);

void main() {
  testWidgets('Tab Tentang dapat dibaca dan pilihan Panduan tetap tersimpan', (
    tester,
  ) async {
    await openApp(tester, width: 320, scale: 1.4);
    await tester.tap(find.text('Panduan').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('guide-search')), 'kelinci');
    await tester.pumpAndSettle();
    expect(find.text('Semua hewan · 2 panduan'), findsOneWidget);

    await tester.tap(find.text('Tentang'));
    await tester.pumpAndSettle();
    expect(find.text('Tentang PetCare'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('PetCare · Versi 1.0.0'),
      180,
      scrollable: verticalScroll(),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Panduan').last);
    await tester.pumpAndSettle();
    expect(find.text('Semua hewan · 2 panduan'), findsOneWidget);
    await tester.tap(find.text('Tentang'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('PetCare'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Kategori, filter, detail, dan kembali mempertahankan item yang benar',
    (tester) async {
      await openApp(tester);
      await tester.ensureVisible(find.text('Kelinci'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kelinci'));
      await tester.pumpAndSettle();
      expect(find.text('Kelinci · 2 panduan'), findsOneWidget);
      await tester.tap(find.widgetWithText(ChoiceChip, 'Nutrisi'));
      await tester.pumpAndSettle();
      expect(find.text('Kelinci · 1 panduan'), findsOneWidget);
      final title = find.text('Menyediakan hay dan air untuk kelinci');
      await tester.scrollUntilVisible(title, 180, scrollable: verticalScroll());
      await tester.pumpAndSettle();
      await tester.tap(title);
      await tester.pumpAndSettle();
      final detail = tester.widget<GuideDetailPage>(
        find.byType(GuideDetailPage),
      );
      expect(detail.guide.id, 'kelinci-hay');
      expect(find.text('Yang disiapkan'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Kelinci · 1 panduan'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Pencarian Beranda diteruskan ke Panduan, empty state dapat direset',
    (tester) async {
      await openApp(tester);
      await tester.enterText(find.byKey(const Key('home-search')), 'KUCING');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.text('Semua hewan · 3 panduan'), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('guide-search')),
        'tidakada123',
      );
      await tester.pumpAndSettle();
      expect(find.text('Panduan tidak ditemukan'), findsOneWidget);
      final reset = find.text('Tampilkan semua panduan');
      await tester.scrollUntilVisible(reset, 180, scrollable: verticalScroll());
      await tester.pumpAndSettle();
      await tester.tap(reset);
      await tester.pumpAndSettle();
      expect(find.text('Semua hewan · 8 panduan'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final width in [320.0, 600.0]) {
    testWidgets(
      'Beranda dan detail dapat discroll pada lebar $width dengan teks besar',
      (tester) async {
        await openApp(tester, width: width, scale: 1.4);
        final title = find.text('Cara menyikat bulu kucing');
        await tester.scrollUntilVisible(
          title,
          200,
          scrollable: verticalScroll(),
        );
        await tester.pumpAndSettle();
        await tester.tap(title);
        await tester.pumpAndSettle();
        expect(
          tester.widget<GuideDetailPage>(find.byType(GuideDetailPage)).guide.id,
          'kucing-bulu',
        );
        await tester.scrollUntilVisible(
          find.text('Catatan'),
          250,
          scrollable: verticalScroll(),
        );
        await tester.pumpAndSettle();
        expect(find.text('Catatan'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
