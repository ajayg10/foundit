import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return report.reportType == 'lost' ? AppTheme.lostRed : AppTheme.recoveryGreen;
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

  IconData _getCategoryIcon(String category) {
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

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(report.status);
    final isLost = report.reportType.toLowerCase() == 'lost';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Thumbnail or Category Icon
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 76,
                  height: 76,
                  color: isLost
                      ? AppTheme.lostRed.withOpacity(0.08)
                      : AppTheme.recoveryGreen.withOpacity(0.08),
                  child: report.imageUrl != null && report.imageUrl!.isNotEmpty
                      ? (report.imageUrl!.startsWith('data:')
                          ? const Center(
                              child: Icon(Icons.image, color: AppTheme.primaryBlue, size: 32),
                            )
                          : Image.network(
                              report.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                _getCategoryIcon(report.category),
                                color: isLost ? AppTheme.lostRed : AppTheme.recoveryGreen,
                                size: 32,
                              ),
                            ))
                      : Icon(
                          _getCategoryIcon(report.category),
                          color: isLost ? AppTheme.lostRed : AppTheme.recoveryGreen,
                          size: 32,
                        ),
                ),
              ),
              const SizedBox(width: 14),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Type Tag + Status Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isLost
                                ? AppTheme.lostRed.withOpacity(0.12)
                                : AppTheme.recoveryGreen.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isLost ? 'LOST' : 'FOUND',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isLost ? AppTheme.lostRed : AppTheme.recoveryGreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            report.status.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat('MMM d, h:mm a').format(report.eventTime.toLocal()),
                          style: GoogleFonts.inter(
                            fontSize: 11,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMain,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Description
                    Text(
                      report.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Location Tag
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppTheme.primaryBlue),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            report.locationLabel,
                            style: GoogleFonts.inter(
                              fontSize: 12,
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
            ],
          ),
        ),
      ),
    );
  }
}
