import 'package:flutter_test/flutter_test.dart';
import 'package:petcare/data/guide_repository.dart';
import 'catalog_fixture.dart';
import 'package:petcare/model/care_guide.dart';
import 'package:petcare/viewmodel/guide_viewmodel.dart';

void main() async {
  test(
    'ViewModel menggabungkan pencarian, hewan, dan topik dari data lokal',
    () async {
      final viewModel = GuideViewModel(repository: const FileGuideRepository());
      await viewModel.loadGuides();
      addTearDown(viewModel.dispose);

      List<CareGuide> search({
        String pet = 'Semua',
        String category = 'Semua',
        String query = '',
      }) {
        viewModel.resetFilters();
        viewModel.setPetType(pet);
        viewModel.setCategory(category);
        viewModel.setQuery(query);
        return viewModel.filteredGuides;
      }

      expect(search().length, 8);
      expect(search(pet: 'Kucing').length, 3);
      expect(
        search(pet: 'Kelinci', category: 'Nutrisi').single.id,
        'kelinci-hay',
      );
      expect(search(query: '  KUCING  ').length, 3);
      expect(search(query: 'MENYIKAT').single.id, 'kucing-bulu');
      expect(search(pet: 'Anjing', category: 'Nutrisi'), isEmpty);
      expect(search(pet: 'Kucing', query: 'kelinci'), isEmpty);
      expect(search(query: 'zzzzzz'), isEmpty);
      expect(search(query: 'kandang').single.id, 'burung-kandang');
    },
  );

  test(
    'Pilihan dari Beranda membuka Panduan dan tab mempertahankan filter',
    () async {
      final viewModel = GuideViewModel(repository: const FileGuideRepository());
      await viewModel.loadGuides();
      addTearDown(viewModel.dispose);
      expect(viewModel.activeTab, 0);
      expect(viewModel.featuredGuide.id, 'anjing-jalan');
      expect(viewModel.popularGuides.map((guide) => guide.id), [
        'kucing-bulu',
        'kelinci-hay',
      ]);
      expect(viewModel.availablePets, [
        'Kucing',
        'Anjing',
        'Kelinci',
        'Burung',
      ]);
      expect(
        viewModel.availableCategories,
        containsAll(['Semua', 'Nutrisi', 'Kebersihan']),
      );

      viewModel.setCategory('Nutrisi');
      viewModel.browse(pet: 'Kucing', query: 'BULU');
      expect(viewModel.activeTab, 1);
      expect(viewModel.openedFromHome, isTrue);
      expect(viewModel.category, 'Semua');
      expect(viewModel.filteredGuides.single.id, 'kucing-bulu');

      viewModel.showHome();
      expect(viewModel.activeTab, 0);
      expect(viewModel.query, 'BULU');
      viewModel.selectTab(1);
      expect(viewModel.openedFromHome, isFalse);
      expect(viewModel.filteredGuides.single.id, 'kucing-bulu');
    },
  );

  test(
    'Perubahan dan reset memberi pembaruan hasil kepada pendengar',
    () async {
      final viewModel = GuideViewModel(repository: const FileGuideRepository());
      await viewModel.loadGuides();
      addTearDown(viewModel.dispose);
      final observedCounts = <int>[];
      viewModel.addListener(
        () => observedCounts.add(viewModel.filteredGuides.length),
      );

      viewModel.browse(pet: 'Kelinci');
      viewModel.setCategory('Nutrisi');
      viewModel.setQuery('zzzzzz');
      viewModel.resetFilters();

      expect(observedCounts, [2, 1, 0, 8]);
      expect(viewModel.petType, 'Semua');
      expect(viewModel.category, 'Semua');
      expect(viewModel.query, isEmpty);
    },
  );
  test('Kegagalan baca JSON dapat dicoba ulang dan hasilnya dimuat', () async {
    final repository = RetryRepository();
    final viewModel = GuideViewModel(repository: repository);
    addTearDown(viewModel.dispose);
    expect(viewModel.isLoading, isTrue);
    await viewModel.loadGuides();
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.errorMessage, isNotNull);
    expect(viewModel.filteredGuides, isEmpty);
    await viewModel.loadGuides();
    expect(viewModel.errorMessage, isNull);
    expect(viewModel.filteredGuides.length, 8);
    expect(viewModel.imageForPet('Kucing'), 'assets/images/cat.jpg');
  });

  test(
    'Pemuat yang selesai setelah dispose tidak mengirim notifikasi',
    () async {
      final viewModel = GuideViewModel(repository: const FileGuideRepository());
      final loading = viewModel.loadGuides();
      viewModel.dispose();
      await expectLater(loading, completes);
    },
  );
}

class RetryRepository extends GuideRepository {
  bool first = true;

  @override
  Future<GuideCatalog> load() async {
    if (first) {
      first = false;
      throw const FormatException('JSON salah');
    }
    return const FileGuideRepository().load();
  }
}
