import 'package:flutter/material.dart';
import '../theme/app_semantic.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

class AppTabItem {
  final String label;
  final int? count;
  const AppTabItem(this.label, [this.count]);
}

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  final TabController controller;
  final List<AppTabItem> tabs;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelPadding: const EdgeInsets.symmetric(
        horizontal: 11,
      ), // 22px gaps (11 on each side)
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: colors.ink, width: 2),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: colors.line,
      labelColor: colors.ink,
      unselectedLabelColor: colors.muted,
      labelStyle: AppText.label(colors.ink),
      unselectedLabelStyle: AppText.label(colors.muted),
      tabs: tabs.map((t) => _buildTab(t, colors)).toList(),
    );
  }

  Widget _buildTab(AppTabItem tab, AppSemantic colors) {
    return Tab(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tab.label),
          if (tab.count != null) ...[
            AppSpacing.hGap4,
            Text(
              '${tab.count}',
              style: AppText.label(
                colors.muted,
              ).copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ],
      ),
    );
  }
}
