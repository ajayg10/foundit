import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'verification_dialog.dart';

/// Displays a match between a lost and found report with:
/// - Animated confidence score bar
/// - Side-by-side comparison (Lost vs Found)
/// - Explainable signal bullets with individual scores
/// - Claim/verify action button
class MatchCard extends StatelessWidget {
  final MatchDetailsDto matchDetails;

  /// Optional — if provided, perspective-aware CTA is shown.
  final String? currentUserId;

  /// Called after successful ownership verification.
  final VoidCallback? onVerified;

  const MatchCard({
    super.key,
    required this.matchDetails,
    this.currentUserId,
    this.onVerified,
  });

  Map<String, dynamic> _parseExplanation(String explanation) {
    try {
      return jsonDecode(explanation) as Map<String, dynamic>;
    } catch (_) {
      final m = matchDetails.match;
      return {
        'percent': (m.confidenceScore * 100).round(),
        'textSummary': 'Strong text and semantic similarity',
        'distanceSummary': '${m.distanceKm.toStringAsFixed(1)} km apart',
        'timeSummary': '${m.timeDiffHours.toStringAsFixed(1)} hours apart',
        'categorySummary': 'Matched categories',
        'verdict': 'Potential match detected',
      };
    }
  }

  Color _confidenceColor(double score) {
    if (score >= 0.85) return const Color(0xFF059669);
    if (score >= 0.65) return const Color(0xFF2563EB);
    return const Color(0xFFD97706);
  }

  String _confidenceLabel(double score) {
    if (score >= 0.85) return '🔥 High Confidence';
    if (score >= 0.65) return '✅ Strong Match';
    return '🔍 Possible Match';
  }

  @override
  Widget build(BuildContext context) {
    final match = matchDetails.match;
    final lost = matchDetails.lostReport;
    final found = matchDetails.foundReport;
    final explanation = _parseExplanation(match.explanation);
    final percent = (match.confidenceScore * 100).round();
    final color = _confidenceColor(match.confidenceScore);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: match.confidenceScore >= 0.80
              ? color.withOpacity(0.35)
              : AppTheme.borderLight,
          width: match.confidenceScore >= 0.80 ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header with animated confidence bar ──────────────────────────
          _ConfidenceHeader(
            score: match.confidenceScore,
            percent: percent,
            color: color,
            label: _confidenceLabel(match.confidenceScore),
            verdict: explanation['verdict'] as String? ?? 'Potential Match',
            isVerified: matchDetails.isVerified,
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Side-by-side comparison ──────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _ReportMini(report: lost, isLost: true)),
                    const SizedBox(width: 10),
                    Expanded(child: _ReportMini(report: found, isLost: false)),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Section label ──────────────────────────────────────
                Text(
                  'WHY THIS MATCH',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 10),

                // ── Signal bullets ────────────────────────────────────
                _SignalBullet(
                  icon: Icons.description_outlined,
                  color: AppTheme.primaryBlue,
                  title: 'Description Match',
                  detail:
                      explanation['textSummary'] as String? ??
                      'Similar item characteristics',
                  score: match.textScore,
                ),
                const SizedBox(height: 6),

                if ((match.locationScore) > 0) ...[
                  _SignalBullet(
                    icon: Icons.place_outlined,
                    color: const Color(0xFF6366F1),
                    title: 'Location',
                    detail:
                        explanation['locationSummary'] as String? ??
                        'Same campus / location',
                    score: match.locationScore,
                  ),
                  const SizedBox(height: 6),
                ],

                _SignalBullet(
                  icon: Icons.near_me_outlined,
                  color: const Color(0xFF0D9488),
                  title: 'Geographic Distance',
                  detail:
                      explanation['distanceSummary'] as String? ??
                      '${match.distanceKm.toStringAsFixed(1)} km apart',
                  score: match.distanceScore,
                ),
                const SizedBox(height: 6),

                _SignalBullet(
                  icon: Icons.schedule_outlined,
                  color: const Color(0xFF8B5CF6),
                  title: 'Time Closeness',
                  detail:
                      explanation['timeSummary'] as String? ??
                      '${match.timeDiffHours.toStringAsFixed(1)} hours apart',
                  score: match.timeScore,
                ),
                const SizedBox(height: 6),

                _SignalBullet(
                  icon: Icons.sell_outlined,
                  color: AppTheme.warningAmber,
                  title: 'Category',
                  detail:
                      explanation['categorySummary'] as String? ??
                      'Category: ${lost.category}',
                  score: match.categoryScore,
                ),

                const SizedBox(height: 16),

                // ── Action button ────────────────────────────────────────
                _ActionBar(matchDetails: matchDetails, onVerified: onVerified),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

/// Animated confidence score header with animated progress bar.
class _ConfidenceHeader extends StatefulWidget {
  final double score;
  final int percent;
  final Color color;
  final String label;
  final String verdict;
  final bool isVerified;

  const _ConfidenceHeader({
    required this.score,
    required this.percent,
    required this.color,
    required this.label,
    required this.verdict,
    required this.isVerified,
  });

  @override
  State<_ConfidenceHeader> createState() => _ConfidenceHeaderState();
}

class _ConfidenceHeaderState extends State<_ConfidenceHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.06),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Score badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.percent}%',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: widget.color,
                      ),
                    ),
                    Text(
                      widget.verdict,
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
              if (widget.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.recoveryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '✓ VERIFIED',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.recoveryGreen,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Animated confidence bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => LinearProgressIndicator(
                value: widget.score * _anim.value,
                minHeight: 5,
                backgroundColor: widget.color.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation(widget.color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ReportMini extends StatelessWidget {
  final ItemReport report;
  final bool isLost;

  const _ReportMini({required this.report, required this.isLost});

  @override
  Widget build(BuildContext context) {
    final color = isLost ? AppTheme.lostRed : AppTheme.recoveryGreen;
    final bg = isLost ? const Color(0xFFFFF1F2) : const Color(0xFFECFDF5);
    final border = isLost ? const Color(0xFFFECDD3) : const Color(0xFFA7F3D0);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isLost ? Icons.search_rounded : Icons.check_circle_outline,
                size: 13,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                isLost ? 'LOST' : 'FOUND',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            report.title,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            report.locationLabel,
            style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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
    final pct = (score * 100).round();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ),
                  Text(
                    '$pct%',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
              Text(
                detail,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: score.clamp(0.0, 1.0),
                  minHeight: 3,
                  backgroundColor: color.withOpacity(0.10),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  final MatchDetailsDto matchDetails;
  final VoidCallback? onVerified;

  const _ActionBar({required this.matchDetails, this.onVerified});

  @override
  Widget build(BuildContext context) {
    final found = matchDetails.foundReport;

    if (matchDetails.isVerified) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.recoveryGreen.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.recoveryGreen.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.recoveryGreen,
              size: 17,
            ),
            const SizedBox(width: 8),
            Text(
              'Ownership Verified — Handover Unlocked',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.recoveryGreen,
              ),
            ),
          ],
        ),
      );
    }

    if (matchDetails.verificationQuestion != null) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.verified_user_outlined, size: 17),
          label: Text(
            'Verify Ownership to Claim',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryDark,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => VerificationDialog(
                reportId: found.id!,
                itemTitle: found.title,
                question: matchDetails.verificationQuestion!,
                onVerificationSuccess: () => onVerified?.call(),
              ),
            );
          },
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.contact_mail_outlined, size: 17),
        label: Text(
          'Contact via Campus Admin',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'No verification challenge set. Contact your campus admin.',
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
      ),
    );
  }
}
