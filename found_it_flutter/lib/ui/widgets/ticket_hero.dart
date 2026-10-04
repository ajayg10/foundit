import 'package:flutter/material.dart';
import '../ui.dart';

class TicketHero extends StatelessWidget {
  final VoidCallback onLostTap;
  final VoidCallback onFoundTap;

  const TicketHero({
    super.key,
    required this.onLostTap,
    required this.onFoundTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final mq = MediaQuery.of(context);
    // Use MediaQuery width + text scale — avoids LayoutBuilder unbounded-height issues.
    final shouldStack = mq.size.width < 350 || mq.textScaler.scale(1) > 1.2;

    final lostBtn = Semantics(
      label: 'Report a lost item',
      button: true,
      child: InkWell(
        onTap: onLostTap,
        borderRadius: shouldStack
            ? BorderRadius.zero
            : const BorderRadius.only(bottomLeft: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s20,
            horizontal: AppSpacing.s16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: colors.error.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.search, color: colors.error, size: 26),
              ),
              AppSpacing.gap12,
              Text(
                'I lost something',
                textAlign: TextAlign.center,
                style: AppText.h3(colors.ink),
              ),
            ],
          ),
        ),
      ),
    );

    final foundBtn = Semantics(
      label: 'Report a found item',
      button: true,
      child: InkWell(
        onTap: onFoundTap,
        borderRadius: shouldStack
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              )
            : const BorderRadius.only(bottomRight: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s20,
            horizontal: AppSpacing.s16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: colors.success.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: colors.success,
                  size: 26,
                ),
              ),
              AppSpacing.gap12,
              Text(
                'I found something',
                textAlign: TextAlign.center,
                style: AppText.h3(colors.ink),
              ),
            ],
          ),
        ),
      ),
    );

    Widget buttons = Flex(
      direction: shouldStack ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (shouldStack) lostBtn else Expanded(child: lostBtn),
        if (!shouldStack)
          VerticalDivider(width: 1, thickness: 1, color: colors.line),
        if (shouldStack) Divider(height: 1, thickness: 1, color: colors.line),
        if (shouldStack) foundBtn else Expanded(child: foundBtn),
      ],
    );

    if (!shouldStack) {
      buttons = IntrinsicHeight(child: buttons);
    }

    // Both buttons use mainAxisSize.min, so they self-size without IntrinsicHeight.
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.panelBr,
        border: Border.all(color: colors.line, width: 1),
        boxShadow: [
          BoxShadow(
            color: colors.ink.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top half: text
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report an item',
                  style: AppText.h2(colors.ink).copyWith(letterSpacing: -0.5),
                ),
                AppSpacing.gap8,
                Text(
                  'Did you lose or find something? Report it here so we can match it using our AI.',
                  style: AppText.body(colors.muted),
                ),
              ],
            ),
          ),
          // Dashed divider with notches — lives inside a fixed-height SizedBox so
          // CustomPaint gets a bounded area even inside a scroll view.
          SizedBox(
            height: 20,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Center(
                    child: SizedBox(
                      height: 1,
                      child: CustomPaint(
                        painter: _DashedLinePainter(
                          color: colors.line,
                          isHorizontal: true,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -10,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 20,
                    decoration: BoxDecoration(
                      color: colors.bg,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.line, width: 1),
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 20,
                    decoration: BoxDecoration(
                      color: colors.bg,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.line, width: 1),
                    ),
                  ),
                ),
                Positioned(
                  left: -11,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 11, color: colors.bg),
                ),
                Positioned(
                  right: -11,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 11, color: colors.bg),
                ),
              ],
            ),
          ),
          // Bottom half: buttons (stacked or side by side)
          buttons,
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final bool isHorizontal;

  _DashedLinePainter({required this.color, required this.isHorizontal});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 5.0;

    if (isHorizontal) {
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, 0),
          Offset(startX + dashWidth, 0),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    } else {
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(0, startY),
          Offset(0, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
