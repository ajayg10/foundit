import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../ui/ui.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'matchFound':
        return Icons.auto_awesome;
      case 'verificationSuccess':
        return Icons.verified_user;
      case 'verificationFailed':
        return Icons.gpp_bad_outlined;
      case 'itemReturned':
        return Icons.celebration;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColorForType(String type, AppSemantic colors) {
    switch (type) {
      case 'matchFound':
        return colors.brand;
      case 'verificationSuccess':
        return colors.success;
      case 'verificationFailed':
        return colors.error;
      case 'itemReturned':
        return colors.found;
      default:
        return colors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final notifications = AppState.instance.notifications;
        final colors = context.colors;

        return AppScaffold(
          appBar: AppBar(
            title: Text(
              'Real-Time Notifications',
              style: AppText.h3(colors.ink),
            ),
            actions: [
              if (notifications.isNotEmpty)
                TextButton(
                  onPressed: () => AppState.instance.markAllNotificationsRead(),
                  child: Text(
                    'Mark all read',
                    style: AppText.label(colors.brand),
                  ),
                ),
            ],
          ),
          body: notifications.isEmpty
              ? const EmptyState(
                  icon: Icons.notifications_none,
                  title: 'No Notifications Yet',
                  body:
                      'You will receive instant alerts here whenever Serverpod finds potential matches or when someone verifies your item.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    final color = _getColorForType(item.type, colors);
                    final icon = _getIconForType(item.type);

                    return InkWell(
                      onTap: () {
                        if (!item.isRead && item.id != null) {
                          AppState.instance.markNotificationRead(item.id!);
                        }
                      },
                      borderRadius: AppRadius.panelBr,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.s16),
                        decoration: BoxDecoration(
                          color: item.isRead
                              ? colors.surface
                              : colors.success.withAlpha(10),
                          borderRadius: AppRadius.panelBr,
                          border: Border.all(
                            color: item.isRead
                                ? colors.line
                                : colors.success.withAlpha(50),
                            width: item.isRead ? 1 : 1.5,
                          ),
                          boxShadow: item.isRead
                              ? null
                              : [
                                  BoxShadow(
                                    color: colors.success.withAlpha(20),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: color.withAlpha(30),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(icon, color: color, size: 20),
                            ),
                            AppSpacing.hGap16,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: AppText.label(
                                            item.isRead
                                                ? colors.ink
                                                : colors.ink,
                                          ),
                                        ),
                                      ),
                                      if (!item.isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: colors.success,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  AppSpacing.gap4,
                                  Text(
                                    item.body,
                                    style: AppText.body(
                                      item.isRead ? colors.muted : colors.ink,
                                    ),
                                  ),
                                  AppSpacing.gap8,
                                  Text(
                                    DateFormat(
                                      'MMM d, h:mm a',
                                    ).format(item.createdAt.toLocal()),
                                    style: AppText.caption(colors.muted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
