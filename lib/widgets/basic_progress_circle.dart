// lib/widgets/basic_progress_circle.dart
import 'package:flutter/material.dart';
import 'dart:math';

class BasicProgressCircle extends StatelessWidget {
  /// portion de l'arc rouge : periodDays / cycleLength (0.0 .. 1.0)
  final double periodFraction;
  final double circleSize;
  final double strokeWidth;
  final Color progressColor;
  final Color trackColor;

  const BasicProgressCircle({
    super.key,
    required this.periodFraction,
    this.circleSize = 220,
    this.strokeWidth = 20,
    this.progressColor = const Color.fromARGB(255, 255, 118, 118),
    this.trackColor = const Color.fromARGB(20, 255, 118, 118),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: CustomPaint(
        painter: _ProgressCirclePainter(
          periodFraction: periodFraction.clamp(0.0, 1.0),
          strokeWidth: strokeWidth,
          progressColor: progressColor,
          trackColor: trackColor,
        ),
      ),
    );
  }
}

class _ProgressCirclePainter extends CustomPainter {
  final double periodFraction;
  final double strokeWidth;
  final Color progressColor;
  final Color trackColor;

  _ProgressCirclePainter({
    required this.periodFraction,
    required this.strokeWidth,
    required this.progressColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - (strokeWidth / 2);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // draw full track (light)
    canvas.drawCircle(center, radius, trackPaint);

    // draw red arc for period portion (start at top, clockwise)
    final startAngle = -pi / 2;
    final sweep = 2 * pi * periodFraction;
    if (sweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressCirclePainter oldDelegate) {
    return oldDelegate.periodFraction != periodFraction ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
