import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'verification_dialog.dart';

class MatchCard extends StatelessWidget {
  final MatchDetailsDto matchDetails;
  final VoidCallback? onVerified;

  const MatchCard({
    super.key,
    required this.matchDetails,
    this.onVerified,
  });

  Map<String, dynamic> _parseExplanation(String explanation) {
    try {
      return jsonDecode(explanation) as Map<String, dynamic>;
    } catch (_) {
      return {
        'percent': (matchDetails.match.confidenceScore * 100).round(),
        'textSummary': 'Strong text and semantic similarity',
        'distanceSummary': '${matchDetails.match.distanceKm} km apart',
        'timeSummary': '${matchDetails.match.timeDiffHours} hours apart',
        'categorySummary': 'Matched categories',
        'verdict': 'Potential match detected',
      };
    }
  }

  Color _getConfidenceColor(double score) {
    if (score >= 0.85) return const Color(0xFF059669); // Emerald
    if (score >= 0.65) return const Color(0xFF2563EB); // Royal Blue
    return const Color(0xFFD97706); // Amber
  }

  @override
  Widget build(BuildContext context) {
    final match = matchDetails.match;
    final lost = matchDetails.lostReport;
    final found = matchDetails.foundReport;
    final explanation = _parseExplanation(match.explanation);
    final percent = (match.confidenceScore * 100).round();
    final badgeColor = _getConfidenceColor(match.confidenceScore);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: match.confidenceScore >= 0.80
              ? badgeColor.withOpacity(0.4)
              : AppTheme.borderLight,
          width: match.confidenceScore >= 0.80 ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Confidence Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        '$percent% CONFIDENCE',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    explanation['verdict'] ?? 'Potential Match',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: badgeColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (matchDetails.isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.recoveryGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'VERIFIED',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.recoveryGreen,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Compare lost vs found cards
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lost Item
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFECDD3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.search, size: 14, color: AppTheme.lostRed),
                                const SizedBox(width: 4),
                                Text(
                                  'LOST REPORT',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.lostRed,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              lost.title,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textMain,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lost.locationLabel,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Found Item
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle_outline, size: 14, color: AppTheme.recoveryGreen),
                                const SizedBox(width: 4),
                                Text(
                                  'FOUND REPORT',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.recoveryGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              found.title,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textMain,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              found.locationLabel,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Text(
                  'WHY THIS MATCH WAS SUGGESTED',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 10),

                // 5 Explainable Signals
                _SignalBullet(
                  icon: Icons.description_outlined,
                  color: AppTheme.primaryBlue,
                  title: 'Description Match',
                  detail: explanation['textSummary'] ?? 'Similar description phrasing',
                  score: match.textScore,
                ),
                const SizedBox(height: 8),

                if (explanation['locationSummary'] != null || match.locationScore > 0) ...[
                  _SignalBullet(
                    icon: Icons.place_outlined,
                    color: const Color(0xFF6366F1),
                    title: 'Location / Campus Context',
                    detail: explanation['locationSummary'] ??
                        (match.locationScore >= 1.0
                            ? 'Both reported at the same campus / location'
                            : 'Nearby campus vicinity'),
                    score: match.locationScore,
                  ),
                  const SizedBox(height: 8),
                ],

                _SignalBullet(
                  icon: Icons.near_me_outlined,
                  color: const Color(0xFF0D9488),
                  title: 'Geographic Distance',
                  detail: explanation['distanceSummary'] ?? '${match.distanceKm} km apart',
                  score: match.distanceScore,
                ),
                const SizedBox(height: 8),

                _SignalBullet(
                  icon: Icons.schedule_outlined,
                  color: const Color(0xFF8B5CF6),
                  title: 'Time Closeness',
                  detail: explanation['timeSummary'] ?? '${match.timeDiffHours} hours apart',
                  score: match.timeScore,
                ),
                const SizedBox(height: 8),

                _SignalBullet(
                  icon: Icons.sell_outlined,
                  color: AppTheme.warningAmber,
                  title: 'Category',
                  detail: explanation['categorySummary'] ?? 'Both are ${lost.category}',
                  score: match.categoryScore,
                ),

                const SizedBox(height: 16),

                // Action Bar
                Row(
                  children: [
                    if (!matchDetails.isVerified && matchDetails.verificationQuestion != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => VerificationDialog(
                                reportId: found.id!,
                                itemTitle: found.title,
                                question: matchDetails.verificationQuestion!,
                                onVerificationSuccess: () {
                                  onVerified?.call();
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.verified_user_outlined, size: 18),
                          label: const Text('Verify Ownership to Claim'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryDark,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      )
                    else if (matchDetails.isVerified)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.recoveryGreen.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.recoveryGreen.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle, color: AppTheme.recoveryGreen, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Ownership Verified — Handover Unlocked',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.recoveryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Finder did not set a verification challenge. Please contact administrator.'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.contact_mail_outlined, size: 18),
                          label: const Text('Contact Finder'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalBullet extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  final double score;

  const _SignalBullet({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (score * 100).round();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMain,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$percent%',
                    style: GoogleFonts.robotoMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
