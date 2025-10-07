// ignore_for_file: deprecated_member_use

import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TemperatureChartWidget extends StatefulWidget {
  final List<PeriodDay> logs;

  const TemperatureChartWidget({super.key, required this.logs});

  @override
  State<TemperatureChartWidget> createState() => _TemperatureChartWidgetState();
}

class _TemperatureChartWidgetState extends State<TemperatureChartWidget> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Filtrer les logs du mois sélectionné
    final monthLogs = widget.logs.where((log) {
      return log.date.year == _focusedMonth.year &&
          log.date.month == _focusedMonth.month &&
          log.temperature != null;
    }).toList()..sort((a, b) => a.date.compareTo(b.date));

    final spots = monthLogs
        .map((log) => FlSpot(log.date.day.toDouble(), log.temperature!))
        .toList();

    final double minY = (spots.isNotEmpty
        ? spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 0.3
        : 35);
    final double maxY = (spots.isNotEmpty
        ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 0.3
        : 38);

    final String monthName = DateFormat(
      'MMMM yyyy',
      'fr_FR',
    ).format(_focusedMonth);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER AVEC LES FLÈCHES ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                ),
                Text(
                  monthName[0].toUpperCase() + monthName.substring(1),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.temperatureChart_description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // --- GRAPHIQUE AGRANDI ---
            SizedBox(
              height: 450, // environ deux fois la taille habituelle (~220)
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LineChart(
                  LineChartData(
                    minY: minY,
                    maxY: maxY,
                    minX: 1,
                    maxX: DateUtils.getDaysInMonth(
                      _focusedMonth.year,
                      _focusedMonth.month,
                    ).toDouble(),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.25,
                        color: colorScheme.primary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colorScheme.primary.withOpacity(0.15),
                        ),
                      ),
                    ],

                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toStringAsFixed(1)}°',
                            style: textTheme.bodySmall,
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 3,
                          getTitlesWidget: (value, meta) {
                            if (value % 3 == 0 || value == 1) {
                              return Text(
                                '${value.toInt()}',
                                style: textTheme.bodySmall,
                              );
                            }
                            return const SizedBox.shrink();
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
                      horizontalInterval: 0.2,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: colorScheme.onSurface.withOpacity(0.1),
                        strokeWidth: 1,
                      ),
                      drawVerticalLine: true,
                      verticalInterval: 3,
                      getDrawingVerticalLine: (value) => FlLine(
                        color: colorScheme.onSurface.withOpacity(0.05),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
