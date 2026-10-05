import 'package:flutter/material.dart';
import '../theme/app_semantic.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

class SummaryPanel extends StatelessWidget {
  const SummaryPanel({
    super.key,
    required this.reportsCount,
    required this.matchesCount,
    required this.returnedCount,
  });

  final int reportsCount;
  final int matchesCount;
  final int returnedCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      color: colors.brand,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildStatColumn(
              context,
              colors,
              reportsCount.toString(),
              'Total\nReports',
            ),
          ),
          _buildDivider(colors),
          Expanded(
            child: _buildStatColumn(
              context,
              colors,
              matchesCount.toString(),
              'Matches\nFound',
            ),
          ),
          _buildDivider(colors),
          Expanded(
            child: _buildStatColumn(
              context,
              colors,
              returnedCount.toString(),
              'Items\nReturned',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(AppSemantic colors) {
    return Container(
      width: 1,
      height: 48,
      color: colors.onBrand.withAlpha(50),
      margin: const EdgeInsets.only(top: 8),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    AppSemantic colors,
    String value,
    String label,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppText.h2(colors.onBrand),
        ),
        AppSpacing.gap4,
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppText.caption(colors.onBrandMuted),
          maxLines: 2,
        ),
      ],
    );
  }
}
