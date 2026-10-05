import 'package:flutter/material.dart';
import '../theme/app_semantic.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Primary, secondary, and tertiary button variants.
///
/// Primary: filled brand (or lost/found color).
/// Secondary: outlined.
/// Tertiary: text-only.
///
/// Loading state shows an inline spinner that keeps the button width.
/// Disabled state uses 38% opacity.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.hero = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool loading;

  /// If true, uses 56 height instead of 48.
  final bool hero;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0,
      upperBound: 1,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _ctrl.forward();
  void _onTapUp(_) => _ctrl.reverse();
  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDisabled = widget.onPressed == null && !widget.loading;
    final height = widget.hero ? 56.0 : 48.0;

    Color bg;
    Color fg;
    Border? border;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        bg = colors.brand;
        fg = colors.onBrand;
      case AppButtonVariant.lost:
        bg = colors.lost;
        fg = colors.surface;
      case AppButtonVariant.found:
        bg = colors.found;
        fg = colors.surface;
      case AppButtonVariant.secondary:
        bg = Colors.transparent;
        fg = colors.ink;
        border = Border.all(color: colors.line);
      case AppButtonVariant.tertiary:
        bg = Colors.transparent;
        fg = colors.brand;
    }

    return Semantics(
      button: true,
      label: widget.label,
      enabled: !isDisabled,
      child: GestureDetector(
        onTapDown: isDisabled || widget.loading ? null : _onTapDown,
        onTapUp: isDisabled || widget.loading ? null : _onTapUp,
        onTapCancel: isDisabled || widget.loading ? null : _onTapCancel,
        onTap: isDisabled || widget.loading ? null : widget.onPressed,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) => Transform.scale(
            scale: _scale.value,
            child: child,
          ),
          child: Opacity(
            opacity: isDisabled ? 0.38 : 1.0,
            child: Container(
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: AppRadius.buttonBr,
                border: border,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.loading)
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(fg),
                      ),
                    )
                  else ...[
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: fg, size: 18),
                      AppSpacing.hGap8,
                    ],
                    Flexible(
                      child: Text(
                        widget.label,
                        style: AppText.label(fg),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum AppButtonVariant { primary, secondary, tertiary, lost, found }
