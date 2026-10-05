import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../ui.dart';
import '../../screens/location_selector_screen.dart';
import '../../screens/notifications_screen.dart';

class BrandHeader extends StatelessWidget {
  final VoidCallback onUserSwitch;
  final VoidCallback onDemoSeed;
  final VoidCallback onLocationChanged;

  const BrandHeader({
    super.key,
    required this.onUserSwitch,
    required this.onDemoSeed,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentUser = AppState.instance.currentUser;
    final unreadCount = AppState.instance.unreadNotificationCount;
    final locName = AppState.instance.currentLocation?.name ?? 'Location';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Logo, text, icons
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s8),
              decoration: BoxDecoration(
                color: colors.brand,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.radar, color: colors.onBrand, size: 20),
            ),
            AppSpacing.hGap12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Found It',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.h2(colors.ink).copyWith(letterSpacing: -0.5),
                  ),
                  Text(
                    'Serverpod Hackathon MVP',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption(colors.muted),
                  ),
                ],
              ),
            ),
            // Notifications Bell (48×48 minimum tap target)
            SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Semantics(
                    label: unreadCount > 0
                        ? 'Notifications, $unreadCount unread'
                        : 'Notifications',
                    button: true,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.notifications_outlined, size: 22),
                      tooltip: 'Notifications',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: ExcludeSemantics(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$unreadCount',
                            textAlign: TextAlign.center,
                            style: AppText.caption(colors.surface).copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Bolt (48×48 minimum tap target)
            SizedBox(
              width: 48,
              height: 48,
              child: Semantics(
                label: 'Seed hackathon demo data',
                button: true,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.bolt, color: colors.warning, size: 22),
                  tooltip: 'Seed Hackathon Demo Data',
                  onPressed: onDemoSeed,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.gap12,
        // Row 2: Location and Identity pills
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Active Campus / Location Pill
            Semantics(
              label: 'Current location: $locName. Tap to change.',
              button: true,
              child: InkWell(
                onTap: () async {
                  final changed = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => const LocationSelectorScreen(),
                    ),
                  );
                  if (changed == true) {
                    onLocationChanged();
                  }
                },
                borderRadius: AppRadius.pillBr,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  constraints: const BoxConstraints(minHeight: 36),
                  decoration: BoxDecoration(
                    color: colors.brand.withAlpha(20),
                    borderRadius: AppRadius.pillBr,
                    border: Border.all(color: colors.brand.withAlpha(50)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.place_rounded,
                        size: 15,
                        color: colors.brand,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: Text(
                          locName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.caption(colors.brand).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: colors.brand,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Active Identity Pill
            Semantics(
              label: 'Current user: ${currentUser.name}. Tap to switch.',
              button: true,
              child: InkWell(
                onTap: onUserSwitch,
                borderRadius: AppRadius.pillBr,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  constraints: const BoxConstraints(minHeight: 36),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: AppRadius.pillBr,
                    border: Border.all(color: colors.line),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: colors.brand,
                        child: ExcludeSemantics(
                          child: Text(
                            currentUser.name.isNotEmpty
                                ? currentUser.name[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 10,
                              color: colors.onBrand,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: Text(
                          currentUser.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.caption(colors.ink).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: colors.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
