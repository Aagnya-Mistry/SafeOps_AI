import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'glass_panel.dart';

class DetectionScene extends StatelessWidget {
  const DetectionScene({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(14),
      child: AspectRatio(
        aspectRatio: 1.08,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF151A20), Color(0xFF090C11)],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _DetectionGridPainter()),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    width: 132,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: AppColors.danger.withValues(alpha: 0.14),
                      border: Border.all(
                        color: AppColors.danger.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'HAZARD ZONE',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.danger,
                              letterSpacing: 1.4,
                            ),
                      ),
                    ),
                  ),
                ),
                const _DetectedWorker(
                  left: 44,
                  top: 62,
                  compliant: true,
                  label: 'Worker A',
                ),
                const _DetectedWorker(
                  left: 156,
                  top: 90,
                  compliant: false,
                  label: 'Worker B',
                ),
                const _DetectedWorker(
                  left: 248,
                  top: 58,
                  compliant: true,
                  label: 'Worker C',
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.42),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      'Live Detection Feed',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetectedWorker extends StatelessWidget {
  const _DetectedWorker({
    required this.left,
    required this.top,
    required this.compliant,
    required this.label,
  });

  final double left;
  final double top;
  final bool compliant;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tone = compliant ? AppColors.success : AppColors.danger;

    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: 92,
        height: 140,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: tone, width: 2),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                      color: tone.withValues(alpha: 0.18),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.05),
              child: CustomPaint(
                size: const Size(54, 90),
                painter: _StickFigurePainter(color: tone),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.48),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: tone),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetectionGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final frame = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final lane = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.12)
      ..strokeWidth = 2;

    for (double y = 0; y <= size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), frame);
    }

    for (double x = 0; x <= size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), frame);
    }

    canvas.drawLine(
      Offset(size.width * 0.06, size.height * 0.74),
      Offset(size.width * 0.9, size.height * 0.42),
      lane,
    );
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.82),
      Offset(size.width * 0.72, size.height * 0.58),
      lane,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StickFigurePainter extends CustomPainter {
  const _StickFigurePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(size.width / 2, 12), 9, paint);
    canvas.drawLine(
      Offset(size.width / 2, 22),
      Offset(size.width / 2, 50),
      paint,
    );
    canvas.drawLine(Offset(size.width / 2, 30), const Offset(12, 42), paint);
    canvas.drawLine(
      Offset(size.width / 2, 30),
      Offset(size.width - 12, 38),
      paint,
    );
    canvas.drawLine(Offset(size.width / 2, 50), const Offset(16, 80), paint);
    canvas.drawLine(
      Offset(size.width / 2, 50),
      Offset(size.width - 16, 78),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
