import 'package:flutter/material.dart';
import '../theme/app_semantic.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Status badge pill for item report statuses.
/// Uses semantic soft background + strong text color + leading dot.
/// Never conveys meaning by color alone — always includes text.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cfg = _config(status, colors);

    return Semantics(
      label: '${cfg.label} status',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          color: cfg.bg,
          borderRadius: AppRadius.pillBr,
          border: Border.all(color: cfg.fg.withAlpha(60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: cfg.fg,
                shape: BoxShape.circle,
              ),
            ),
            AppSpacing.hGap4,
            Text(
              cfg.label,
              style: AppText.caption(cfg.fg).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _BadgeCfg _config(String status, AppSemantic colors) {
    switch (status.toLowerCase()) {
      case 'lost':
        return _BadgeCfg(colors.lost, colors.lostSoft, 'Lost');
      case 'found':
        return _BadgeCfg(colors.found, colors.foundSoft, 'Found');
      case 'open':
        return _BadgeCfg(colors.muted, colors.surface, 'Open');
      case 'matched':
        return _BadgeCfg(colors.brand, colors.brand.withAlpha(30), 'Matched');
      case 'claimpending':
        return _BadgeCfg(colors.warning, colors.warningSoft, 'Claim pending');
      case 'verified':
        return _BadgeCfg(colors.found, colors.foundSoft, 'Verified');
      case 'returned':
        return _BadgeCfg(colors.found, colors.foundSoft, 'Returned');
      default:
        return _BadgeCfg(colors.muted, colors.bg, status);
    }
  }
}

class _BadgeCfg {
  const _BadgeCfg(this.fg, this.bg, this.label);
  final Color fg;
  final Color bg;
  final String label;
}

/// Chip for filters, categories, toggles.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s8,
        ),
        decoration: BoxDecoration(
          color: selected ? colors.ink : colors.surface,
          borderRadius: AppRadius.pillBr,
          border: Border.all(
            color: selected ? colors.ink : colors.line,
          ),
        ),
        child: Text(
          label,
          style: AppText.caption(
            selected ? colors.surface : colors.ink,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Section header with optional trailing text button.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.trailingLabel,
    this.onTrailingTap,
  });

  final String title;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppText.h3(colors.ink),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailingLabel != null && onTrailingTap != null) ...[
          AppSpacing.hGap8,
          TextButton(
            onPressed: onTrailingTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s8,
                vertical: AppSpacing.s4,
              ),
            ),
            child: Text(
              trailingLabel!,
              style: AppText.label(colors.brand),
            ),
          ),
        ],
      ],
    );
  }
}
