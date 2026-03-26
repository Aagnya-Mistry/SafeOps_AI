import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            AppColors.backgroundSoft,
            Color(0xFF0B1118),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _GridPainter())),
          ),
          Positioned(
            top: -80,
            right: -20,
            child: _GlowOrb(
              size: 240,
              color: AppColors.accent.withValues(alpha: 0.2),
            ),
          ),
          Positioned(
            left: -100,
            bottom: 90,
            child: _GlowOrb(
              size: 260,
              color: AppColors.accentBright.withValues(alpha: 0.12),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.outline.withValues(alpha: 0.25)
      ..strokeWidth = 1;

    for (double x = 0; x <= size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (double y = 0; y <= size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final accentPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.06)
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.16),
      Offset(size.width * 0.92, size.height * 0.16),
      accentPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.84),
      Offset(size.width * 0.78, size.height * 0.84),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
