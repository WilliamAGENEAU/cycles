import 'dart:math';
import 'package:flutter/material.dart';

class BasicProgressCircle extends StatefulWidget {
  final double periodFraction;
  final double ovulationStartFraction;
  final double ovulationFraction;
  final double circleSize;
  final double strokeWidth;
  final int dayInCycle;
  final int cycleLength;

  // Nouveau : indique s'il y a des données à afficher ; si false on affiche le placeholder
  final bool hasData;
  final String? placeholderMessage;

  const BasicProgressCircle({
    super.key,
    required this.periodFraction,
    required this.ovulationStartFraction,
    required this.ovulationFraction,
    required this.circleSize,
    required this.strokeWidth,
    required this.dayInCycle,
    required this.cycleLength,
    this.hasData = true,
    this.placeholderMessage,
  });

  @override
  State<BasicProgressCircle> createState() => _BasicProgressCircleState();
}

class _BasicProgressCircleState extends State<BasicProgressCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final animatedDay = (widget.dayInCycle * _animation.value).clamp(
          0.0,
          widget.dayInCycle.toDouble(),
        );
        return CustomPaint(
          size: Size(widget.circleSize, widget.circleSize),
          painter: _BasicProgressCirclePainter(
            periodFraction: widget.periodFraction,
            ovulationStartFraction: widget.ovulationStartFraction,
            ovulationFraction: widget.ovulationFraction,
            strokeWidth: widget.strokeWidth,
            dayInCycle: animatedDay.toInt(),
            cycleLength: widget.cycleLength,
            hasData: widget.hasData,
            placeholderMessage: widget.placeholderMessage,
          ),
        );
      },
    );
  }
}

class _BasicProgressCirclePainter extends CustomPainter {
  final double periodFraction;
  final double ovulationStartFraction;
  final double ovulationFraction;
  final double strokeWidth;
  final int dayInCycle;
  final int cycleLength;

  // nouveau
  final bool hasData;
  final String? placeholderMessage;

  _BasicProgressCirclePainter({
    required this.periodFraction,
    required this.ovulationStartFraction,
    required this.ovulationFraction,
    required this.strokeWidth,
    required this.dayInCycle,
    required this.cycleLength,
    this.hasData = true,
    this.placeholderMessage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -pi / 2;

    // 🎨 Cercle de fond (teinte douce)
    final paintBase = Paint()
      ..color = const Color.fromARGB(20, 255, 118, 118)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, paintBase);

    // Si pas de données : on affiche uniquement le cercle de fond + message centré
    if (!hasData) {
      final message = placeholderMessage ?? 'Veuillez enregistrer une période';
      final tp = TextPainter(
        text: TextSpan(
          text: message,
          style: TextStyle(
            color: Colors.white, // <-- couleur blanche
            fontSize: size.width * 0.06, // <-- plus petit
            fontWeight: FontWeight.w600,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 2,
      );
      tp.layout(maxWidth: radius * 1.6);
      tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
      return;
    }

    // 🔴 Période (règles)
    final paintPeriod = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * pi * periodFraction,
      false,
      paintPeriod,
    );

    // 🔵 Fenêtre d’ovulation
    final paintOvulation = Paint()
      ..color = const Color(0xFF64B5F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + 2 * pi * ovulationStartFraction,
      2 * pi * ovulationFraction,
      false,
      paintOvulation,
    );

    // 🔹 Indicateur du jour actuel
    if (dayInCycle > 0 && cycleLength > 0) {
      final fraction = (dayInCycle % cycleLength) / cycleLength;
      final angle = startAngle + 2 * pi * fraction;

      final indicatorX = center.dx + radius * cos(angle);
      final indicatorY = center.dy + radius * sin(angle);
      final indicatorCenter = Offset(indicatorX, indicatorY);

      // Cercle du jour
      final paintIndicator = Paint()
        ..color = Colors.blueGrey.shade700
        ..style = PaintingStyle.fill;

      const double smallCircleSize = 34;
      canvas.drawCircle(indicatorCenter, smallCircleSize / 2, paintIndicator);

      // Texte du jour
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$dayInCycle',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        indicatorCenter - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // ➡️ Flèche de direction (Icon)
    final arrowAngle = startAngle + 2 * pi - 0.25; // légèrement avant la fin
    final arrowOffset = Offset(
      center.dx + radius * cos(arrowAngle),
      center.dy + radius * sin(arrowAngle),
    );

    // on dessine l'icône flèche via TextPainter (utilise un symbole)
    const icon = Icons.arrow_forward;
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.grey.shade500,
          fontSize: 18,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();

    canvas.save();
    canvas.translate(arrowOffset.dx, arrowOffset.dy);
    canvas.rotate(arrowAngle + pi / 2);
    canvas.translate(-iconPainter.width / 2, -iconPainter.height / 2);
    iconPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BasicProgressCirclePainter oldDelegate) =>
      oldDelegate.periodFraction != periodFraction ||
      oldDelegate.ovulationStartFraction != ovulationStartFraction ||
      oldDelegate.ovulationFraction != ovulationFraction ||
      oldDelegate.dayInCycle != dayInCycle ||
      oldDelegate.cycleLength != cycleLength ||
      oldDelegate.hasData != hasData ||
      oldDelegate.placeholderMessage != placeholderMessage;
}
