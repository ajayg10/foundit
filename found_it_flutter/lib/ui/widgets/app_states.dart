import 'package:flutter/material.dart';
import '../theme/app_semantic.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Empty state with a CustomPainter line illustration, h3 title,
/// one-sentence body, and optional primary action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _EmptyIllustration(color: colors.line, icon: icon),
              AppSpacing.gap24,
              Text(
                title,
                style: AppText.h3(colors.ink),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gap8,
              Text(
                body,
                style: AppText.body(colors.muted),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                AppSpacing.gap24,
                FilledButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration({required this.color, this.icon});
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(80, 80),
      painter: _IllustrationPainter(color: color, icon: icon),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  _IllustrationPainter({required this.color, this.icon});
  final Color color;
  final IconData? icon;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.75
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;

    // Circle
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // Crossed lines inside (generic "nothing here" feel)
    final innerR = r * 0.5;
    canvas.drawLine(
      Offset(cx - innerR, cy - innerR),
      Offset(cx + innerR, cy + innerR),
      paint,
    );
    canvas.drawLine(
      Offset(cx + innerR, cy - innerR),
      Offset(cx - innerR, cy + innerR),
      paint,
    );
  }

  @override
  bool shouldRepaint(_IllustrationPainter old) => old.color != color;
}

/// Error state with icon and "Try again" button.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                color: colors.muted,
                size: 48,
              ),
              AppSpacing.gap16,
              Text(
                message,
                style: AppText.body(colors.muted),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gap20,
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton list placeholder with slow opacity pulse.
class SkeletonList extends StatefulWidget {
  const SkeletonList({super.key, this.itemCount = 4});
  final int itemCount;

  @override
  State<SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _opacity = Tween(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.s16),
        itemCount: widget.itemCount,
        separatorBuilder: (_, __) => AppSpacing.gap12,
        itemBuilder: (_, __) => Opacity(
          opacity: _opacity.value,
          child: _SkeletonCard(),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: colors.line,
        borderRadius: AppRadius.tileBr,
      ),
    );
  }
}

/// Small inline spinner for buttons and inline loading.
class AppSpinner extends StatelessWidget {
  const AppSpinner({super.key, this.size = 20, this.color});
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(
          color ?? context.colors.brand,
        ),
      ),
    );
  }
}
