import 'package:flutter/material.dart';
import '../model/care_guide.dart';
import '../viewmodel/guide_viewmodel.dart';
import 'widgets.dart';

class GuideListPage extends StatefulWidget {
  const GuideListPage({
    super.key,
    required this.viewModel,
    required this.onGuideSelected,
    this.onBack,
  });
  final GuideViewModel viewModel;
  final ValueChanged<CareGuide> onGuideSelected;
  final VoidCallback? onBack;
  @override
  State<GuideListPage> createState() => _GuideListPageState();
}

class _GuideListPageState extends State<GuideListPage> {
  late final TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.viewModel.query);
  }

  @override
  void didUpdateWidget(covariant GuideListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_searchController.text != widget.viewModel.query) {
      _searchController.value = TextEditingValue(
        text: widget.viewModel.query,
        selection: TextSelection.collapsed(
          offset: widget.viewModel.query.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final filtered = widget.viewModel.filteredGuides;
    return CustomScrollView(
      key: const PageStorageKey('guide-scroll'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          sliver: SliverList.list(
            children: [
              Row(
                children: [
                  if (widget.onBack != null) ...[
                    IconButton(
                      tooltip: 'Kembali ke Beranda',
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text('Panduan', style: theme.textTheme.headlineSmall),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                key: const Key('guide-search'),
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: widget.viewModel.setQuery,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: 'Cari panduan perawatan',
                  prefixIcon: const Icon(Icons.search, size: 21),
                  suffixIcon: widget.viewModel.query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          onPressed: () => widget.viewModel.setQuery(''),
                          icon: const Icon(Icons.close, size: 19),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Jenis hewan', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 2,
                children: [
                  for (final pet in [
                    'Semua',
                    ...widget.viewModel.availablePets,
                  ])
                    ChoiceChip(
                      label: Text(pet),
                      selected: widget.viewModel.petType == pet,
                      onSelected: (_) => widget.viewModel.setPetType(pet),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Topik perawatan', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 2,
                children: [
                  for (final category in widget.viewModel.availableCategories)
                    ChoiceChip(
                      label: Text(category),
                      selected: widget.viewModel.category == category,
                      onSelected: (_) => widget.viewModel.setCategory(category),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        '${widget.viewModel.petType == 'Semua' ? 'Semua hewan' : widget.viewModel.petType} · ${filtered.length} panduan',
                        key: const Key('guide-count'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.viewModel.resetFilters,
                    child: const Text('Atur ulang'),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
        if (filtered.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 38,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Panduan tidak ditemukan',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coba kata kunci lain atau atur ulang filter.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: widget.viewModel.resetFilters,
                    child: const Text('Tampilkan semua panduan'),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            sliver: SliverList.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final guide = filtered[index];
                return GuideCard(
                  key: ValueKey(guide.id),
                  guide: guide,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    widget.onGuideSelected(guide);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class GuideDetailPage extends StatelessWidget {
  const GuideDetailPage({super.key, required this.guide});
  final CareGuide guide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.07,
                        child: Image.asset(
                          guide.imagePath,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.6),
                          semanticLabel: guide.petType,
                          errorBuilder: (_, error, stackTrace) => ColoredBox(
                            color: colors.primaryContainer,
                            child: Icon(
                              Icons.pets,
                              size: 64,
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 16,
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: BackButton(
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 19,
                      right: 18,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.schedule, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              '${guide.readingMinutes} menit baca',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 7,
                        children: [
                          for (final label in [guide.petType, guide.category])
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primaryContainer,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                label,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Text(guide.title, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 10),
                      Text(
                        guide.summary,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yang disiapkan',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 15),
                            for (
                              var i = 0;
                              i < guide.materials.length;
                              i++
                            ) ...[
                              if (i > 0) const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 18,
                                    color: colors.onPrimaryContainer,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      guide.materials[i],
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'Langkah perawatan',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 17),
                      for (var i = 0; i < guide.steps.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 19),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: colors.primaryContainer,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  '${i + 1}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colors.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  guide.steps[i],
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer.withValues(
                            alpha: 0.65,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 17,
                                  color: colors.onPrimaryContainer,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Catatan',
                                  style: theme.textTheme.titleSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 9),
                            Text(guide.note, style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
