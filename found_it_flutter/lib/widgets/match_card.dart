import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import '../ui/ui.dart';
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

  Color _confidenceColor(double score, AppSemantic colors) {
    if (score >= 0.85) return colors.success;
    if (score >= 0.65) return colors.brand;
    return colors.warning;
  }

  String _confidenceLabel(double score) {
    if (score >= 0.85) return '🔥 High Confidence';
    if (score >= 0.65) return '✅ Strong Match';
    return '🔍 Possible Match';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final match = matchDetails.match;
    final lost = matchDetails.lostReport;
    final found = matchDetails.foundReport;
    final explanation = _parseExplanation(match.explanation);
    final percent = (match.confidenceScore * 100).round();
    final color = _confidenceColor(match.confidenceScore, colors);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.tileBr,
        border: Border.all(
          color: match.confidenceScore >= 0.80
              ? color.withAlpha(90)
              : colors.line,
          width: match.confidenceScore >= 0.80 ? 1.5 : 1,
        ),
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
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Side-by-side comparison ──────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _ReportMini(report: lost, isLost: true)),
                    AppSpacing.hGap8,
                    Expanded(child: _ReportMini(report: found, isLost: false)),
                  ],
                ),

                AppSpacing.gap16,

                // ── Section label ──────────────────────────────────────
                Text(
                  'WHY THIS MATCH',
                  style: AppText.caption(colors.muted).copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                AppSpacing.gap8,

                // ── Signal bullets ────────────────────────────────────
                _SignalBullet(
                  icon: Icons.description_outlined,
                  color: colors.brand,
                  title: 'Description Match',
                  detail:
                      explanation['textSummary'] as String? ??
                      'Similar item characteristics',
                  score: match.textScore,
                ),
                AppSpacing.gap8,

                if ((match.locationScore) > 0) ...[
                  _SignalBullet(
                    icon: Icons.place_outlined,
                    color: colors.brand,
                    title: 'Location',
                    detail:
                        explanation['locationSummary'] as String? ??
                        'Same campus / location',
                    score: match.locationScore,
                  ),
                  AppSpacing.gap8,
                ],

                _SignalBullet(
                  icon: Icons.near_me_outlined,
                  color: colors.brand,
                  title: 'Geographic Distance',
                  detail:
                      explanation['distanceSummary'] as String? ??
                      '${match.distanceKm.toStringAsFixed(1)} km apart',
                  score: match.distanceScore,
                ),
                AppSpacing.gap8,

                _SignalBullet(
                  icon: Icons.schedule_outlined,
                  color: colors.brand,
                  title: 'Time Closeness',
                  detail:
                      explanation['timeSummary'] as String? ??
                      '${match.timeDiffHours.toStringAsFixed(1)} hours apart',
                  score: match.timeScore,
                ),
                AppSpacing.gap8,

                _SignalBullet(
                  icon: Icons.sell_outlined,
                  color: colors.brand,
                  title: 'Category',
                  detail:
                      explanation['categorySummary'] as String? ??
                      'Category: ${lost.category}',
                  score: match.categoryScore,
                ),

                AppSpacing.gap16,

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
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s12,
        AppSpacing.s16,
        AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        color: widget.color.withAlpha(15),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.tile),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Score badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: AppRadius.pillBr,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 13,
                    ),
                    AppSpacing.hGap4,
                    Text(
                      '${widget.percent}%',
                      style: AppText.caption(Colors.white).copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.hGap8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: AppText.label(widget.color),
                    ),
                    Text(
                      widget.verdict,
                      style: AppText.caption(colors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (widget.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s8,
                    vertical: AppSpacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.success.withAlpha(38),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '✓ VERIFIED',
                    style: AppText.caption(colors.success).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          AppSpacing.gap8,
          // Animated confidence bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => LinearProgressIndicator(
                value: widget.score * _anim.value,
                minHeight: 5,
                backgroundColor: widget.color.withAlpha(30),
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
    final colors = context.colors;
    final color = isLost ? colors.lost : colors.found;
    final bg = isLost ? colors.lostSoft : colors.foundSoft;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isLost ? Icons.search_rounded : Icons.check_circle_outline,
                size: 14,
                color: color,
              ),
              AppSpacing.hGap4,
              Expanded(
                child: Text(
                  isLost ? 'LOST' : 'FOUND',
                  style: AppText.caption(color).copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppSpacing.gap4,
          Text(
            report.title,
            style: AppText.label(colors.ink),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.gap4,
          Text(
            report.locationLabel,
            style: AppText.caption(colors.muted),
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
    final colors = context.colors;
    final pct = (score * 100).round();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.s4),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        AppSpacing.hGap8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppText.label(colors.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$pct%',
                    style: AppText.label(color),
                  ),
                ],
              ),
              Text(
                detail,
                style: AppText.caption(colors.muted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.gap4,
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: score.clamp(0.0, 1.0),
                  minHeight: 3,
                  backgroundColor: color.withAlpha(25),
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
    final colors = context.colors;
    final found = matchDetails.foundReport;

    if (matchDetails.isVerified) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
        decoration: BoxDecoration(
          color: colors.success.withAlpha(25),
          borderRadius: AppRadius.buttonBr,
          border: Border.all(color: colors.success.withAlpha(60)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: colors.success,
              size: 18,
            ),
            AppSpacing.hGap8,
            Text(
              'Ownership Verified — Handover Unlocked',
              style: AppText.label(colors.success),
            ),
          ],
        ),
      );
    }

    if (matchDetails.verificationQuestion != null) {
      return SizedBox(
        width: double.infinity,
        child: AppButton(
          label: 'Verify Ownership to Claim',
          icon: Icons.verified_user_outlined,
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
      child: AppButton(
        label: 'Contact via Campus Admin',
        icon: Icons.contact_mail_outlined,
        variant: AppButtonVariant.secondary,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No verification challenge set. Contact your campus admin.',
              ),
            ),
          );
        },
      ),
    );
  }
}
