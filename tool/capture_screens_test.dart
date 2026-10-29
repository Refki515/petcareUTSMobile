import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petcare/main.dart';

void main() {
  testWidgets('Ekspor empat layar Flutter', (tester) async {
    var sdk = File(Platform.resolvedExecutable).parent;
    while (!Directory(
      '${sdk.path}/bin/cache/artifacts/material_fonts',
    ).existsSync()) {
      if (sdk.parent.path == sdk.path) {
        throw StateError(
          'Jalankan melalui flutter test agar SDK dapat ditemukan.',
        );
      }
      sdk = sdk.parent;
    }
    final fontPath = '${sdk.path}/bin/cache/artifacts/material_fonts';
    await tester.runAsync(() async {
      final roboto = FontLoader('Roboto');
      for (final face in ['regular', 'medium', 'bold']) {
        roboto.addFont(
          File(
            '$fontPath/roboto-$face.ttf',
          ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
        );
      }
      await roboto.load();
      final fallback = FontLoader('Ahem')
        ..addFont(
          File(
            '$fontPath/roboto-regular.ttf',
          ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
        );
      await fallback.load();
      final icons = FontLoader('MaterialIcons')
        ..addFont(
          File(
            '$fontPath/materialicons-regular.otf',
          ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
        );
      await icons.load();
    });
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(key: boundaryKey, child: const PetCareApp()),
    );
    await tester.runAsync(() async {
      await rootBundle.loadString('assets/data/guides.json');
    });
    await tester.pumpAndSettle();
    final context = tester.element(find.text('PetCare'));
    await tester.runAsync(() async {
      for (final image in ['cat', 'dog', 'rabbit', 'bird']) {
        if (!context.mounted) return;
        await precacheImage(AssetImage('assets/images/$image.jpg'), context);
      }
    });
    await tester.pumpAndSettle();

    Future<void> capture(String name) async {
      await tester.pumpAndSettle();
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
        final file = File('docs/screenshots/$name.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes.buffer.asUint8List());
        image.dispose();
      });
    }

    await capture('beranda');
    await tester.tap(find.text('Kucing'));
    await tester.pumpAndSettle();
    await capture('panduan');
    final vertical = find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    );
    await tester.scrollUntilVisible(
      find.text('Cara menyikat bulu kucing'),
      180,
      scrollable: vertical,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cara menyikat bulu kucing'));
    await tester.pumpAndSettle();
    await capture('detail');
    await tester.scrollUntilVisible(
      find.text('Catatan'),
      200,
      scrollable: vertical,
    );
    await tester.pumpAndSettle();
    await capture('detail-langkah');
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tentang'));
    await tester.pumpAndSettle();
    await capture('tentang');
    expect(tester.takeException(), isNull);
  });
}
