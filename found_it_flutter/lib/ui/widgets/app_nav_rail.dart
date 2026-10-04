import 'package:flutter/material.dart';
import '../theme/app_semantic.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import 'app_bottom_nav.dart'; // To reuse AppNavDestination

/// Vertical navigation rail for tablet and desktop layouts (>= 600dp width).
class AppNavRail extends StatelessWidget {
  const AppNavRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.extended = false,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AppNavDestination> destinations;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: extended ? 256 : 80,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(right: BorderSide(color: colors.line, width: 1)),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.s24),
            // Optional logo placeholder for extended rail
            if (extended)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: colors.brand, size: 28),
                    AppSpacing.hGap12,
                    Expanded(
                      child: Text(
                        'Found It',
                        style: AppText.h3(colors.ink),
                      ),
                    ),
                  ],
                ),
              )
            else
              Icon(Icons.location_on, color: colors.brand, size: 28),
            const SizedBox(height: AppSpacing.s32),
            Expanded(
              child: ListView.builder(
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final dest = destinations[index];
                  final isSelected = index == selectedIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s12,
                      vertical: AppSpacing.s8,
                    ),
                    child: InkWell(
                      onTap: () => onDestinationSelected(index),
                      borderRadius: AppRadius.tileBr,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.s12,
                          horizontal: extended ? AppSpacing.s16 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? colors.brand.withAlpha(25) : Colors.transparent,
                          borderRadius: AppRadius.tileBr,
                        ),
                        child: extended
                            ? Row(
                                children: [
                                  Icon(
                                    isSelected ? dest.selectedIcon : dest.icon,
                                    color: isSelected ? colors.brand : colors.muted,
                                  ),
                                  AppSpacing.hGap16,
                                  Expanded(
                                    child: Text(
                                      dest.label,
                                      style: AppText.body(isSelected ? colors.brand : colors.muted)
                                          .copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
                                    ),
                                  ),
                                  if (dest.badgeCount != null && dest.badgeCount! > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: colors.brand,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${dest.badgeCount}',
                                        style: AppText.micro(colors.onBrand),
                                      ),
                                    ),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Badge(
                                    isLabelVisible: dest.badgeCount != null && dest.badgeCount! > 0,
                                    label: Text('${dest.badgeCount ?? ""}'),
                                    backgroundColor: colors.brand,
                                    child: Icon(
                                      isSelected ? dest.selectedIcon : dest.icon,
                                      color: isSelected ? colors.brand : colors.muted,
                                    ),
                                  ),
                                  AppSpacing.gap4,
                                  Text(
                                    dest.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected ? colors.brand : colors.muted,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
