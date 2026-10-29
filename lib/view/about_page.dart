import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return ListView(
      key: const PageStorageKey('about-scroll'),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Text('Tentang PetCare', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 32),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.pets, size: 34, color: colors.onPrimary),
          ),
        ),
        const SizedBox(height: 18),
        Text('Teman merawat hewanmu', style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),
        Text(
          'PetCare membantu kamu menemukan panduan perawatan sehari-hari '
          'untuk kucing, anjing, kelinci, dan burung.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 28),
        const Divider(),
        const SizedBox(height: 24),
        Text('Cara menggunakan', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        for (final item in const [
          (
            Icons.pets_outlined,
            'Pilih hewan',
            'Pilih jenis hewan di Beranda atau tab Panduan.',
          ),
          (
            Icons.search,
            'Temukan panduan',
            'Cari judul atau pilih topik perawatan yang kamu butuhkan.',
          ),
          (
            Icons.menu_book_outlined,
            'Baca langkahnya',
            'Ketuk kartu untuk melihat perlengkapan, langkah, dan catatan.',
          ),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.$1, size: 22, color: colors.onPrimaryContainer),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$2, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(item.$3, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const Divider(),
        const SizedBox(height: 20),
        Text('Bisa dibaca tanpa internet', style: theme.textTheme.titleSmall),
        const SizedBox(height: 6),
        Text(
          'Panduan dan foto tersedia langsung di aplikasi.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Text( 'PetCare · Versi 1.0.0', style: theme.textTheme.bodySmall),
      ],
    );
  }
}
