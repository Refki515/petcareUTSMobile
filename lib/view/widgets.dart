import 'package:flutter/material.dart';
import '../model/care_guide.dart';

class PetCategoryChip extends StatelessWidget {
  const PetCategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
    this.isSelected = false,
    this.imagePath,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isSelected;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      selected: isSelected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: isSelected ? colors.primary : Colors.white,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 13, 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: imagePath == null
                        ? ColoredBox(
                            color: backgroundColor,
                            child: Icon(icon, size: 18, color: foregroundColor),
                          )
                        : Image.asset(
                            imagePath!,
                            fit: BoxFit.cover,
                            alignment: const Alignment(0, -0.6),
                            errorBuilder: (_, error, stackTrace) => ColoredBox(
                              color: backgroundColor,
                              child: Icon(
                                icon,
                                size: 18,
                                color: foregroundColor,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? colors.onPrimary
                        : colors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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

class GuideCard extends StatelessWidget {
  const GuideCard({
    super.key,
    required this.guide,
    required this.onTap,
    this.featured = false,
  });

  final CareGuide guide;
  final VoidCallback onTap;
  final bool featured;

  Widget _image(BuildContext context, {double? width, double? height}) =>
      Image.asset(
        guide.imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        alignment: const Alignment(0, -0.55),
        semanticLabel: guide.petType,
        errorBuilder: (_, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.pets_outlined,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: featured ? 56 : 28,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    if (featured) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(11, 12, 11, 0),
                child: AspectRatio(
                  aspectRatio: 1.03,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: Transform.rotate(
                          angle: 0.065,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFCEC2A3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Transform.rotate(
                          angle: -0.045,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: _image(context),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.94),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            guide.category,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 14,
                        bottom: 14,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 21,
                            color: colors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(11, 18, 11, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(guide.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 5),
                    Text(
                      '${guide.petType} · ${guide.readingMinutes} menit baca',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: _image(context, width: 68, height: 88),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${guide.petType} · ${guide.category}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(guide.title, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 5),
                    Text(
                      guide.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 19,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
