// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cycles/models/flows/flow_enum.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/models/periods/period.dart';

class TemperatureCycleChart extends StatefulWidget {
  final List<PeriodDay> logs;
  final List<Period> periods;

  const TemperatureCycleChart({
    super.key,
    required this.logs,
    required this.periods,
  });

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
    if (widget.periods.isEmpty) {
      _cycles = [];
      return;
    }

    final sortedPeriods = [...widget.periods]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final List<Map<String, DateTime>> cycles = [];

    for (int i = 0; i < sortedPeriods.length; i++) {
      final start = sortedPeriods[i].startDate;
      DateTime end;

      if (i < sortedPeriods.length - 1) {
        // Fin du cycle = veille du prochain début de règles
        end = sortedPeriods[i + 1].startDate.subtract(const Duration(days: 1));
      } else {
        // Dernier cycle : jusqu’à aujourd’hui
        end = DateTime.now();
      }

      if (!end.isBefore(start)) {
        cycles.add({'start': start, 'end': end});
      }
    }

    _cycles = cycles;

    // Sélection du cycle en cours (celui qui contient aujourd’hui)
    final now = DateTime.now();
    final indexCurrent = _cycles.lastIndexWhere(
      (c) => !now.isBefore(c['start']!) && !now.isAfter(c['end']!),
    );
    _currentCycleIndex = indexCurrent >= 0 ? indexCurrent : _cycles.length - 1;
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

    // Logs appartenant à ce cycle
    final cycleLogs =
        widget.logs
            .where((log) => !log.date.isBefore(start) && !log.date.isAfter(end))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    if (cycleLogs.isEmpty) {
      return const Center(child: Text('Aucune donnée de température.'));
    }

    // Points de température
    final spots = <FlSpot>[];
    for (final log in cycleLogs) {
      if (log.temperature == null) continue;
      final dayIndex = log.date.difference(start).inDays + 1;
      spots.add(FlSpot(dayIndex.toDouble(), log.temperature!));
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cycleLength = end.difference(start).inDays + 1;

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
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
          const SizedBox(height: 12),
          Text(
            "Évolution de la température au cours du cycle",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // --- LINE CHART ---
          SizedBox(
            height: 420,
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: cycleLength.toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: _buildColoredLineSegments(
                  spots,
                  cycleLogs,
                  colorScheme,
                  start,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 50),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 2,
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

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            Transform.rotate(
                              angle: -math.pi / 3,
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
                  horizontalInterval: 0.2,
                  getDrawingVerticalLine: (value) => FlLine(
                    color: colorScheme.onSurface.withOpacity(0.05),
                    strokeWidth: 1,
                  ),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colorScheme.onSurface.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<LineChartBarData> _buildColoredLineSegments(
    List<FlSpot> spots,
    List<PeriodDay> cycleLogs,
    ColorScheme colorScheme,
    DateTime start,
  ) {
    if (spots.isEmpty) return [];

    final tempByDay = {for (final s in spots) s.x.toInt(): s.y};
    final minDay = tempByDay.keys.reduce((a, b) => a < b ? a : b);
    final maxDay = tempByDay.keys.reduce((a, b) => a > b ? a : b);

    bool isFlowDay(int d) {
      final dayDate = start.add(Duration(days: d - 1));
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
    bool currentIsFlow = isFlowDay(minDay);

    FlSpot? lastSpot;
    for (int d = minDay; d <= maxDay; d++) {
      if (!tempByDay.containsKey(d)) continue;
      final spot = FlSpot(d.toDouble(), tempByDay[d]!);
      final dayFlow = isFlowDay(d);

      if (lastSpot == null) {
        currentSegment = [spot];
        currentIsFlow = dayFlow;
      } else {
        if (dayFlow != currentIsFlow) {
          segments.add(
            _createSegment(currentSegment, currentIsFlow, colorScheme),
          );
          // relier en bleu entre segments
          segments.add(
            _createSegment([currentSegment.last, spot], false, colorScheme),
          );
          currentSegment = [spot];
          currentIsFlow = dayFlow;
        } else {
          currentSegment.add(spot);
        }
      }

      lastSpot = spot;
    }

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
      isCurved: false,
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
