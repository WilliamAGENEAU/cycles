import 'package:cycles/models/pills/pill_status_enum.dart';
import 'package:flutter/material.dart';

class PillCircle extends StatelessWidget {
  final int dayNumber;
  final PillVisualStatus status;

  const PillCircle({super.key, required this.dayNumber, required this.status});

  @override
  Widget build(BuildContext context) {
    final visuals = status.getVisuals(context, dayNumber);

    return Container(
      decoration: visuals.decoration,
      child: Center(child: visuals.child),
    );
  }
}
