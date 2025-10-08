// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cycles/models/flows/flow_enum.dart';
import 'package:cycles/models/period_logs/period_day.dart';

class TemperatureCycleChart extends StatefulWidget {
  final List<PeriodDay> logs;
  const TemperatureCycleChart({super.key, required this.logs});

  @override
  State<TemperatureCycleChart> createState() => _TemperatureCycleChartState();
}

class _TemperatureCycleChartState extends State<TemperatureCycleChart> {
  late List<Map<String, DateTime>> _cycles;
  int _currentCycleIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCycles();
  }

  void _initCycles() {
    final sortedLogs = [...widget.logs]
      ..sort((a, b) => a.date.compareTo(b.date));

    if (sortedLogs.isEmpty) {
      _cycles = [];
      return;
    }

    final List<Map<String, DateTime>> cycles = [];
    DateTime? currentStart;

    for (int i = 0; i < sortedLogs.length; i++) {
      final current = sortedLogs[i];
      final prev = i > 0 ? sortedLogs[i - 1] : null;

      // Si flux ce jour ET (pas de jour précédent OU jour précédent sans flux)
      if (current.flow != FlowRate.none &&
          (prev == null || prev.flow == FlowRate.none)) {
        currentStart = current.date;
      }

      final next = i < sortedLogs.length - 1 ? sortedLogs[i + 1] : null;

      // Détecte fin de cycle: soit prochain flux démarre -> fin = veille du prochain flux,
      // soit dernier log -> fin = today
      if (currentStart != null &&
          (next == null ||
              (next.flow != FlowRate.none &&
                  next.date.isAfter(current.date)))) {
        DateTime endDate;
        if (next != null && next.flow != FlowRate.none) {
          endDate = next.date.subtract(const Duration(days: 1));
        } else if (next == null) {
          endDate = DateTime.now();
        } else {
          endDate = current.date;
        }

        if (!endDate.isBefore(currentStart)) {
          cycles.add({'start': currentStart, 'end': endDate});
        }
        currentStart = null;
      }
    }

    // Si on est encore dans un cycle en cours
    if (currentStart != null) {
      _cycles.add({'start': currentStart, 'end': DateTime.now()});
    }

    _cycles = cycles;
  }

  void _nextCycle() {
    if (_currentCycleIndex < _cycles.length - 1) {
      setState(() => _currentCycleIndex++);
    }
  }

  void _previousCycle() {
    if (_currentCycleIndex > 0) {
      setState(() => _currentCycleIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cycles.isEmpty) {
      return const Center(child: Text('Aucun cycle détecté.'));
    }

    final cycle = _cycles[_currentCycleIndex];
    final start = cycle['start']!;
    final end = cycle['end']!;

    final cycleLogs =
        widget.logs
            .where((log) => !log.date.isBefore(start) && !log.date.isAfter(end))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    if (cycleLogs.isEmpty) {
      return const Center(child: Text('Aucune donnée de température.'));
    }

    // Création des points de température (1..N : jours du cycle)
    final spots = <FlSpot>[];
    for (final log in cycleLogs) {
      if (log.temperature == null) continue;
      final dayIndex = log.date.difference(start).inDays + 1;
      spots.add(FlSpot(dayIndex.toDouble(), log.temperature!));
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final cycleLength = end.difference(start).inDays + 1;
    // minY/maxY calculés sur les températures disponibles
    final temps = cycleLogs
        .where((l) => l.temperature != null)
        .map((l) => l.temperature!)
        .toList();
    final double minY = (temps.isNotEmpty
        ? temps.reduce((a, b) => a < b ? a : b) - 0.3
        : 35);
    final double maxY = (temps.isNotEmpty
        ? temps.reduce((a, b) => a > b ? a : b) + 0.3
        : 38);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- HEADER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousCycle,
                ),
                Flexible(
                  child: Text(
                    'Cycle du ${DateFormat("d/MM").format(start)} au ${DateFormat("d/MM").format(end)}',
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextCycle,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Évolution de la température au cours du cycle",
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // --- GRAPHIQUE ---
            // augmenter la hauteur pour laisser de la place aux labels inclinés
            SizedBox(
              height: 420,

              child: LineChart(
                LineChartData(
                  minX: 1,
                  maxX: cycleLength.toDouble(),
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    // On colorie par point : si jour a flux -> rose, sinon bleu.
                    // Pour garder une courbe continue tout en colorant segments,
                    // on génère deux LineChartBarData: une pour les jours "sans flux" (bleue),
                    // et une pour les jours "avec flux" (rose) — en pratique on doit
                    // séparer les spots en segments contigus.
                    ..._buildColoredLineSegments(spots, cycleLogs, colorScheme),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, _) => Text(
                          '${value.toStringAsFixed(1)}°',
                          style: textTheme.bodySmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        // <-- IMPORTANT : augmenter reservedSize pour éviter overflow
                        reservedSize: 35,
                        interval: 2,
                        // margin permet d'ajouter encore de l'espace si nécessaire
                        // (SideTitles dans certaines versions de fl_chart supporte margin)
                        getTitlesWidget: (value, meta) {
                          final day = value.toInt();
                          if (day < 1 || day > cycleLength) {
                            return const SizedBox.shrink();
                          }

                          final date = start.add(Duration(days: day - 1));
                          final isFlowDay = cycleLogs.any(
                            (log) =>
                                log.date.year == date.year &&
                                log.date.month == date.month &&
                                log.date.day == date.day &&
                                log.flow != FlowRate.none,
                          );

                          // Column with MainAxisSize.min to avoid expanding vertically
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // numéro du jour du cycle
                              Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isFlowDay
                                      ? Colors.pink
                                      : colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // date du mois (rotated slightly)
                              Transform.rotate(
                                angle: -math.pi / 3, // léger angle (~-18°)
                                alignment: Alignment.center,
                                child: Text(
                                  DateFormat('d/MM').format(date),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    verticalInterval: 2,
                    horizontalInterval: 0.2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: colorScheme.onSurface.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: colorScheme.onSurface.withOpacity(0.05),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<LineChartBarData> _buildColoredLineSegments(
    List<FlSpot> spots,
    List<PeriodDay> cycleLogs,
    ColorScheme colorScheme,
  ) {
    if (spots.isEmpty) return [];

    // Map jour -> température
    final tempByDay = {for (final s in spots) s.x.toInt(): s.y};

    final int minDay = spots
        .map((s) => s.x.toInt())
        .reduce((a, b) => a < b ? a : b);
    final int maxDay = spots
        .map((s) => s.x.toInt())
        .reduce((a, b) => a > b ? a : b);

    // Détermine si chaque jour a du flux
    bool isFlowDay(int d) {
      final dayDate = cycleLogs.first.date.add(Duration(days: d - 1));
      return cycleLogs.any(
        (log) =>
            log.date.year == dayDate.year &&
            log.date.month == dayDate.month &&
            log.date.day == dayDate.day &&
            log.flow != FlowRate.none,
      );
    }

    final List<LineChartBarData> segments = [];
    List<FlSpot> currentSegment = [];
    bool currentIsFlow = false;

    FlSpot? lastSpot;

    for (int d = minDay; d <= maxDay; d++) {
      // Si pas de température ce jour, on interpole rien, mais on continue la ligne.
      if (!tempByDay.containsKey(d)) continue;

      final temp = tempByDay[d]!;
      final spot = FlSpot(d.toDouble(), temp);
      final bool dayFlow = isFlowDay(d);

      if (lastSpot == null) {
        // Premier point
        currentSegment = [spot];
        currentIsFlow = dayFlow;
      } else {
        // Changement de type (flux/non flux)
        if (dayFlow != currentIsFlow) {
          // On ferme le segment précédent avec une ligne bleue vers le nouveau point
          segments.add(
            _createSegment(currentSegment, currentIsFlow, colorScheme),
          );

          // Important : relier le dernier point du segment précédent
          // au nouveau point avec une ligne bleue (non flux)
          segments.add(
            _createSegment(
              [currentSegment.last, spot],
              false, // bleu
              colorScheme,
            ),
          );

          // Nouveau segment à partir du point actuel
          currentSegment = [spot];
          currentIsFlow = dayFlow;
        } else {
          currentSegment.add(spot);
        }
      }

      lastSpot = spot;
    }

    // Ajout du dernier segment
    if (currentSegment.isNotEmpty) {
      segments.add(_createSegment(currentSegment, currentIsFlow, colorScheme));
    }

    return segments;
  }

  LineChartBarData _createSegment(
    List<FlSpot> segSpots,
    bool isFlowSegment,
    ColorScheme colorScheme,
  ) {
    return LineChartBarData(
      spots: segSpots,
      isCurved: false, // ligne droite entre les points (résultat demandé)
      barWidth: 3,
      color: isFlowSegment ? Colors.pink : colorScheme.primary,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: (isFlowSegment ? Colors.pinkAccent : colorScheme.primary)
            .withOpacity(0.12),
      ),
    );
  }
}
