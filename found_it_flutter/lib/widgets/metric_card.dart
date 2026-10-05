import 'package:flutter/material.dart';
import '../ui/ui.dart';

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final String? subtitle;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final content = Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.tileBr,
        border: Border.all(
          color: onTap != null ? color.withAlpha(60) : colors.line,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s12),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: AppRadius.buttonBr,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          AppSpacing.hGap16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: AppText.numeral(colors.ink),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (onTap != null) ...[
                      AppSpacing.hGap8,
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: colors.muted,
                      ),
                    ],
                  ],
                ),
                Text(
                  label,
                  style: AppText.label(colors.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  AppSpacing.gap4,
                  Text(
                    subtitle!,
                    style: AppText.caption(colors.muted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.tileBr,
          child: content,
        ),
      );
    }

    return content;
  }
}
