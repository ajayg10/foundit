import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

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

  Color get _typeColor => report.reportType.toLowerCase() == 'lost'
      ? AppTheme.lostRed
      : AppTheme.recoveryGreen;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return _typeColor;
      case 'matched':
        return AppTheme.matchIndigo;
      case 'claimpending':
        return AppTheme.warningAmber;
      case 'verified':
        return AppTheme.recoveryGreen;
      case 'returned':
        return const Color(0xFF64748B);
      default:
        return AppTheme.primaryBlue;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'claimpending':
        return 'CLAIM PENDING';
      default:
        return status.toUpperCase();
    }
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

  Widget _photoWidget() {
    final img = report.imageUrl;
    if (img != null && img.isNotEmpty) {
      // Base64 encoded image
      if (img.startsWith('data:image')) {
        try {
          final base64Str = img.split(',').last;
          final bytes = base64Decode(base64Str);
          return Image.memory(
            Uint8List.fromList(bytes),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => _iconPlaceholder(),
          );
        } catch (_) {
          return _iconPlaceholder();
        }
      }
      // Network URL
      return Image.network(
        img,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : _iconPlaceholder(),
        errorBuilder: (_, __, ___) => _iconPlaceholder(),
      );
    }
    return _iconPlaceholder();
  }

  Widget _iconPlaceholder() {
    return Icon(
      _categoryIcon(report.category),
      color: _typeColor,
      size: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLost = report.reportType.toLowerCase() == 'lost';
    final sc = _statusColor(report.status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: _typeColor, width: 5),
            top: const BorderSide(color: AppTheme.borderLight),
            right: const BorderSide(color: AppTheme.borderLight),
            bottom: const BorderSide(color: AppTheme.borderLight),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Photo thumbnail ──────────────────────────────────────
            Container(
              width: 76,
              height: 76,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _typeColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _photoWidget(),
              ),
            ),

            // ── Content ──────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges row
                    Row(
                      children: [
                        _chip(
                          isLost ? 'LOST' : 'FOUND',
                          _typeColor,
                          _typeColor.withOpacity(0.12),
                        ),
                        const SizedBox(width: 5),
                        _chip(
                          _statusLabel(report.status),
                          sc,
                          sc.withOpacity(0.10),
                        ),
                        const Spacer(),
                        Text(
                          _relativeTime(report.eventTime),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Title
                    Text(
                      report.title,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textMain,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    // Description
                    Text(
                      report.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Location row
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: AppTheme.primaryBlue,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            report.locationLabel,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textMain,
                            ),
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
      ),
    );
  }

  Widget _chip(String text, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
