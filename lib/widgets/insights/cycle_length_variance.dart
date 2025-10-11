// ignore_for_file: deprecated_member_use

import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/periods/period.dart';
import 'package:flutter/material.dart';

class CycleLengthVarianceWidget extends StatefulWidget {
  final List<Period> periods;

  const CycleLengthVarianceWidget({super.key, required this.periods});

  @override
  State<CycleLengthVarianceWidget> createState() =>
      _CycleLengthVarianceWidgetState();
}

class _CycleLengthVarianceWidgetState extends State<CycleLengthVarianceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Crée un effet d’apparition échelonnée pour les 4 sous-cards
    _fadeAnimations = List.generate(
      4,
      (i) => CurvedAnimation(
        parent: _controller,
        curve: Interval(i * 0.1, 0.6 + i * 0.1, curve: Curves.easeOut),
      ),
    );

    _scaleAnimations = List.generate(
      4,
      (i) => CurvedAnimation(
        parent: _controller,
        curve: Interval(i * 0.1, 0.6 + i * 0.1, curve: Curves.decelerate),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? _calculateVariance(List<double> values) {
    if (values.length < 2) return null;
    double totalDiff = 0;
    for (int i = 0; i < values.length - 1; i++) {
      totalDiff += (values[i] - values[i + 1]).abs();
    }
    return totalDiff / values.length;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final periods = widget.periods;

    if (periods.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(child: Text("No data")),
        ),
      );
    }

    final List<Period> reversedPeriods = periods.reversed.toList();

    // --- Calcul des durées de cycle ---
    final List<double> cycleLengths = [];
    for (int i = 0; i < reversedPeriods.length - 1; i++) {
      final current = reversedPeriods[i];
      final next = reversedPeriods[i + 1];
      final diff = next.startDate.difference(current.startDate).inDays;
      cycleLengths.add(diff.toDouble());
    }

    // --- Moyennes ---
    final double avgCycle = cycleLengths.isNotEmpty
        ? cycleLengths.reduce((a, b) => a + b) / cycleLengths.length
        : 0;

    final double avgPeriod =
        reversedPeriods
            .map((p) => p.totalDays.toDouble())
            .reduce((a, b) => a + b) /
        reversedPeriods.length;

    // --- Variances ---
    final List<double> periodDurations = reversedPeriods
        .map((p) => p.totalDays.toDouble())
        .toList();
    final double? variancePeriod = _calculateVariance(periodDurations);
    final double? varianceCycle = _calculateVariance(cycleLengths);

    // --- Sous-card stylée et animée ---
    Widget buildAnimatedSubCard(
      int index,
      String title,
      String value,
      Color accentColor,
    ) {
      return FadeTransition(
        opacity: _fadeAnimations[index],
        child: ScaleTransition(
          scale: _scaleAnimations[index],
          child: Card(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            elevation: 2,
            shadowColor: accentColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 12.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    value,
                    style: textTheme.headlineSmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final cards = [
      buildAnimatedSubCard(
        0,
        l10n.cycleLengthVarianceWidget_averageCycle,
        avgCycle > 0 ? l10n.dayCount(avgCycle.round()) : "No data",
        colorScheme.primary,
      ),
      buildAnimatedSubCard(
        1,
        l10n.cycleLengthVarianceWidget_averagePeriod,
        avgPeriod > 0 ? l10n.dayCount(avgPeriod.round()) : "No data",
        colorScheme.primary,
      ),

      buildAnimatedSubCard(
        3,
        l10n.cycleLengthVarianceWidget_cycleVariance,
        varianceCycle != null
            ? "${varianceCycle.toStringAsFixed(1)} j"
            : "No data",
        colorScheme.primary,
      ),
      buildAnimatedSubCard(
        2,
        l10n.cycleLengthVarianceWidget_periodVariance,
        variancePeriod != null
            ? "${variancePeriod.toStringAsFixed(1)} j"
            : "No data",
        colorScheme.primary,
      ),
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.cycleLengthVarianceWidget_cycleAndPeriodVeriance,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              children: cards,
            ),
          ],
        ),
      ),
    );
  }
}
