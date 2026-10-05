import 'package:flutter/material.dart';
import '../theme/app_semantic.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Standard screen top bar with back button, title, and optional trailing actions.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
    this.onBack,
    this.bottom,
    this.showBackButton = true,
  });

  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppBar(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? Semantics(
              label: 'Go back',
              button: true,
              child: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.s8),
                child: InkWell(
                  onTap: onBack ?? () => Navigator.of(context).maybePop(),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.line),
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: colors.ink,
                      size: 20,
                    ),
                  ),
                ),
              ),
            )
          : null,
      leadingWidth: showBackButton ? 52 : null,
      title: Text(
        title,
        style: AppText.h2(colors.ink),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: actions,
      bottom: bottom,
      shape: Border(bottom: BorderSide(color: colors.line, width: 1)),
    );
  }
}
