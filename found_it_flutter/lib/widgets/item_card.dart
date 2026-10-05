import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:intl/intl.dart';
import '../ui/ui.dart';

/// Rich item card that shows:
/// - Left accent border colored by report type
/// - Photo thumbnail (supports base64, network URL, or category icon)
/// - LOST/FOUND badge + status chip + relative time
/// - Title, truncated description, location
class ItemCard extends StatelessWidget {
  final ItemReport report;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ItemCard({
    super.key,
    required this.report,
    this.onTap,
    this.trailing,
  });

  Color _typeColor(BuildContext context) {
    final colors = context.colors;
    return report.reportType.toLowerCase() == 'lost'
        ? colors.lost
        : colors.found;
  }

  Color _typeSoftColor(BuildContext context) {
    final colors = context.colors;
    return report.reportType.toLowerCase() == 'lost'
        ? colors.lostSoft
        : colors.foundSoft;
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'bags':
        return Icons.backpack_outlined;
      case 'electronics':
        return Icons.devices_outlined;
      case 'keys':
        return Icons.vpn_key_outlined;
      case 'wallets & purses':
        return Icons.account_balance_wallet_outlined;
      case 'documents & ids':
        return Icons.badge_outlined;
      case 'clothing':
        return Icons.checkroom_outlined;
      case 'jewelry & accessories':
        return Icons.watch_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  /// Relative time label e.g. "2h ago", "Just now"
  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt.toLocal());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dt.toLocal());
  }

  Widget _photoWidget(BuildContext context) {
    final img = report.imageUrl;
    if (img != null && img.isNotEmpty) {
      if (img.startsWith('data:image')) {
        try {
          final base64Str = img.split(',').last;
          final bytes = base64Decode(base64Str);
          return Image.memory(
            Uint8List.fromList(bytes),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => _iconPlaceholder(context),
          );
        } catch (_) {
          return _iconPlaceholder(context);
        }
      }
      return Image.network(
        img,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : _iconPlaceholder(context),
        errorBuilder: (_, __, ___) => _iconPlaceholder(context),
      );
    }
    return _iconPlaceholder(context);
  }

  Widget _iconPlaceholder(BuildContext context) {
    return Icon(
      _categoryIcon(report.category),
      color: _typeColor(context),
      size: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLost = report.reportType.toLowerCase() == 'lost';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Left accent border spanning full card height
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: ColoredBox(color: _typeColor(context)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 4),

                // ── Photo thumbnail ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s12),
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: _typeSoftColor(context),
                      borderRadius: AppRadius.buttonBr,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _photoWidget(context),
                  ),
                ),

                // ── Content ──────────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.s12,
                      right: AppSpacing.s16,
                      bottom: AppSpacing.s12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badges row
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: AppSpacing.s8,
                          runSpacing: AppSpacing.s4,
                          children: [
                            StatusBadge(status: isLost ? 'Lost' : 'Found'),
                            if (report.status.toLowerCase() != 'open')
                              StatusBadge(status: report.status),
                            Text(
                              _relativeTime(report.eventTime),
                              style: AppText.caption(colors.muted),
                            ),
                          ],
                        ),
                        AppSpacing.gap4,

                        // Title
                        Text(
                          report.title,
                          style: AppText.h3(colors.ink),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AppSpacing.gap4,

                        // Description
                        Text(
                          report.description,
                          style: AppText.body(colors.muted),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Location row
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: colors.brand,
                            ),
                            AppSpacing.hGap4,
                            Expanded(
                              child: Text(
                                report.locationLabel,
                                style: AppText.caption(colors.ink),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (trailing != null) trailing!,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
