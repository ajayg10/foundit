import 'package:flutter/material.dart';
import '../ui.dart';

class StatBento extends StatelessWidget {
  final int matchedCount;
  final int lostCount;
  final int foundCount;
  final int returnedCount;
  final String locationName;

  final VoidCallback onMatchesTap;
  final VoidCallback onLostTap;
  final VoidCallback onFoundTap;
  final VoidCallback onReturnedTap;

  const StatBento({
    super.key,
    required this.matchedCount,
    required this.lostCount,
    required this.foundCount,
    required this.returnedCount,
    required this.locationName,
    required this.onMatchesTap,
    required this.onLostTap,
    required this.onFoundTap,
    required this.onReturnedTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left: AI Matched (large brand tile)
              Expanded(
                flex: 5,
                child: InkWell(
                  onTap: onMatchesTap,
                  borderRadius: AppRadius.panelBr,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s20),
                    decoration: BoxDecoration(
                      color: colors.brand,
                      borderRadius: AppRadius.panelBr,
                      boxShadow: [
                        BoxShadow(
                          color: colors.ink.withAlpha(8),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.onBrand.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.auto_awesome, color: colors.onBrand, size: 28),
                        ),
                        AppSpacing.gap12,
                        Text(
                          '$matchedCount',
                          style: AppText.display(colors.onBrand),
                        ),
                        Text(
                          'AI Matched',
                          style: AppText.h3(colors.onBrandMuted),
                        ),
                        Text(
                          'Tap to view matches',
                          style: AppText.caption(colors.onBrandMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppSpacing.hGap12,
              // Right: Lost and Found
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _SmallBentoTile(
                      label: 'Lost Reported',
                      value: '$lostCount',
                      subtitle: 'By you',
                        icon: Icons.search,
                        iconColor: colors.error,
                        onTap: onLostTap,
                      ),
                    AppSpacing.gap12,
                    _SmallBentoTile(
                      label: 'Found Posted',
                        value: '$foundCount',
                        subtitle: 'In $locationName',
                        icon: Icons.check_circle_outline,
                        iconColor: colors.success,
                        onTap: onFoundTap,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gap12,
        // Bottom: Items Returned
        InkWell(
          onTap: onReturnedTap,
          borderRadius: AppRadius.tileBr,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s20,
              vertical: AppSpacing.s16,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.tileBr,
              border: Border.all(color: colors.line),
              boxShadow: [
                BoxShadow(
                  color: colors.ink.withAlpha(4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s8),
                  decoration: BoxDecoration(
                    color: colors.success.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.handshake_outlined, color: colors.success, size: 24),
                ),
                AppSpacing.hGap16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items Returned',
                        style: AppText.h3(colors.ink),
                      ),
                      Text(
                        'Resolved in area',
                        style: AppText.caption(colors.muted),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$returnedCount',
                  style: AppText.h2(colors.ink),
                ),
                AppSpacing.hGap12,
                Icon(Icons.arrow_forward_ios, size: 14, color: colors.muted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallBentoTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SmallBentoTile({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.tileBr,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.tileBr,
          border: Border.all(color: colors.line),
          boxShadow: [
            BoxShadow(
              color: colors.ink.withAlpha(4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 22),
            AppSpacing.hGap12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: AppText.h2(colors.ink).copyWith(height: 1.0),
                  ),
                  Text(
                    label,
                    style: AppText.caption(colors.ink).copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: AppText.caption(colors.muted).copyWith(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
