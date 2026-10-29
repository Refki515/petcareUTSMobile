import 'package:flutter/material.dart';
import '../model/care_guide.dart';
import '../viewmodel/guide_viewmodel.dart';
import 'about_page.dart';
import 'guide_pages.dart';
import 'widgets.dart';

class PetCareShell extends StatefulWidget {
  const PetCareShell({super.key});
  @override
  State<PetCareShell> createState() => _PetCareShellState();
}

class _PetCareShellState extends State<PetCareShell> {
  final _viewModel = GuideViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadGuides();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openGuide(CareGuide guide) => Navigator.of(context).push<void>(
    MaterialPageRoute(builder: (_) => GuideDetailPage(guide: guide)),
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (_viewModel.errorMessage != null) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 36),
                      const SizedBox(height: 12),
                      Text(
                        _viewModel.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _viewModel.loadGuides,
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return PopScope(
          canPop: _viewModel.activeTab == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) _viewModel.showHome();
          },
          child: Scaffold(
            body: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: IndexedStack(
                    index: _viewModel.activeTab,
                    children: [
                      HomePage(
                        viewModel: _viewModel,
                        onGuideSelected: _openGuide,
                      ),
                      GuideListPage(
                        viewModel: _viewModel,
                        onGuideSelected: _openGuide,
                        onBack: _viewModel.openedFromHome
                            ? _viewModel.showHome
                            : null,
                      ),
                      const AboutPage(),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
                child: Center(
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BottomNavigationBar(
                        currentIndex: _viewModel.activeTab,
                        onTap: _viewModel.selectTab,
                        backgroundColor: const Color(0xFF171717),
                        elevation: 0,
                        selectedItemColor: colors.primary,
                        unselectedItemColor: const Color(0xFFBBBBBB),
                        selectedFontSize: 12,
                        unselectedFontSize: 12,
                        items: [
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.home_outlined),
                            activeIcon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.home_outlined,
                                size: 20,
                                color: colors.onPrimary,
                              ),
                            ),
                            label: 'Beranda',
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.menu_book_outlined),
                            activeIcon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.menu_book_outlined,
                                size: 20,
                                color: colors.onPrimary,
                              ),
                            ),
                            label: 'Panduan',
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.info_outline),
                            activeIcon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.info_outline,
                                size: 20,
                                color: colors.onPrimary,
                              ),
                            ),
                            label: 'Tentang',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.onGuideSelected,
    required this.viewModel,
  });
  final ValueChanged<CareGuide> onGuideSelected;
  final GuideViewModel viewModel;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    widget.viewModel.browse(query: _searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final featured = widget.viewModel.featuredGuide;
    final petTypes = widget.viewModel.availablePets;
    final otherPopular = widget.viewModel.popularGuides;
    return ListView(
      key: const PageStorageKey('home-scroll'),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.pets, color: colors.onPrimary, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang di',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text('PetCare', style: theme.textTheme.titleLarge),
                ],
              ),
            ),
            ClipOval(
              child: Image.asset(
                'assets/images/cat.jpg',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.7),
                excludeFromSemantics: true,
                errorBuilder: (_, error, stackTrace) => CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  child: const Icon(Icons.pets),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('home-search'),
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: 'Cari panduan perawatan',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: IconButton(
                    tooltip: 'Cari panduan',
                    onPressed: _search,
                    icon: const Icon(Icons.arrow_forward, size: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            SizedBox(
              width: 48,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: widget.viewModel.browse,
                child: const Tooltip(
                  message: 'Jelajahi semua panduan',
                  child: Icon(Icons.tune_rounded, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text('Pilih hewan', style: theme.textTheme.titleSmall),
            ),
            TextButton(
              onPressed: widget.viewModel.browse,
              child: const Text('Lihat semua'),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < petTypes.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                PetCategoryChip(
                  label: petTypes[i],
                  icon: Icons.pets_outlined,
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.onPrimaryContainer,
                  imagePath: widget.viewModel.imageForPet(petTypes[i]),
                  isSelected: petTypes[i] == featured.petType,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    widget.viewModel.browse(pet: petTypes[i]);
                  },
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 23),
        Text('Panduan pilihan', style: theme.textTheme.titleSmall),
        const SizedBox(height: 6),
        GuideCard(
          guide: featured,
          featured: true,
          onTap: () => widget.onGuideSelected(featured),
        ),
        const SizedBox(height: 17),
        Text('Perawatan sehari-hari', style: theme.textTheme.titleSmall),
        const SizedBox(height: 13),
        for (var i = 0; i < otherPopular.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          GuideCard(
            guide: otherPopular[i],
            onTap: () => widget.onGuideSelected(otherPopular[i]),
          ),
        ],
      ],
    );
  }
}
