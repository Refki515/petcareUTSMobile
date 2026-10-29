import 'package:flutter/foundation.dart';

import '../data/guide_repository.dart';
import '../model/care_guide.dart';

class GuideViewModel extends ChangeNotifier {
  GuideViewModel({GuideRepository repository = const GuideRepository()})
    : _repository = repository;

  final GuideRepository _repository;
  GuideCatalog? _catalog;
  bool _isLoading = true;
  bool _requestInProgress = false;
  bool _disposed = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CareGuide> get _guides => _catalog?.guides ?? const [];

  Future<void> loadGuides() async {
    if (_requestInProgress || _disposed) return;
    _requestInProgress = true;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final catalog = await _repository.load();
      if (_disposed) return;
      _catalog = catalog;
    } catch (_) {
      if (_disposed) return;
      _errorMessage = 'Panduan belum bisa dimuat. Silakan coba lagi.';
    } finally {
      _requestInProgress = false;
      if (!_disposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  int _activeTab = 0;
  String _petType = 'Semua';
  String _category = 'Semua';
  String _query = '';
  bool _openedFromHome = false;

  int get activeTab => _activeTab;
  String get petType => _petType;
  String get category => _category;
  String get query => _query;
  bool get openedFromHome => _openedFromHome;
  List<String> get availablePets => _catalog?.petTypes ?? const [];
  List<String> get availableCategories => _catalog?.categories ?? const [];

  String? imageForPet(String pet) {
    for (final guide in _guides) {
      if (guide.petType == pet) return guide.imagePath;
    }
    return null;
  }

  CareGuide get featuredGuide =>
      _guides.firstWhere((guide) => guide.id == _catalog!.featuredGuideId);

  List<CareGuide> get popularGuides => _guides
      .where((guide) => _catalog!.popularGuideIds.contains(guide.id))
      .toList(growable: false);

  List<CareGuide> get filteredGuides {
    final keyword = _query.trim().toLowerCase();
    return _guides
        .where((guide) {
          final matchesPet = _petType == 'Semua' || guide.petType == _petType;
          final matchesCategory =
              _category == 'Semua' || guide.category == _category;
          final matchesQuery =
              keyword.isEmpty ||
              '${guide.title} ${guide.petType}'.toLowerCase().contains(keyword);
          return matchesPet && matchesCategory && matchesQuery;
        })
        .toList(growable: false);
  }

  void browse({String pet = 'Semua', String query = ''}) {
    _activeTab = 1;
    _petType = pet;
    _category = 'Semua';
    _query = query;
    _openedFromHome = true;
    notifyListeners();
  }

  void selectTab(int index) {
    assert(index >= 0 && index <= 2);
    _activeTab = index;
    _openedFromHome = false;
    notifyListeners();
  }

  void showHome() {
    _activeTab = 0;
    notifyListeners();
  }

  void setPetType(String value) {
    if (_petType == value) return;
    _petType = value;
    notifyListeners();
  }

  void setCategory(String value) {
    if (_category == value) return;
    _category = value;
    notifyListeners();
  }

  void setQuery(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void resetFilters() {
    _petType = 'Semua';
    _category = 'Semua';
    _query = '';
    notifyListeners();
  }
}
