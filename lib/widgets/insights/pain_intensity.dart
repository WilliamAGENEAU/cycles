import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/period_logs/humeur_level_enum.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:flutter/material.dart';

class HumeurBreakdownWidget extends StatelessWidget {
  final List<PeriodDay> logs;
  const HumeurBreakdownWidget({super.key, required this.logs});

  Widget _buildBar(
    BuildContext context, {
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final percentage = total > 0 ? (count / total) : 0.0;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label (${l10n.dayCount(count)})', style: textTheme.bodyMedium),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          color: color,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    if (logs.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(child: Text(l10n.painLevelWidget_noPainDataLoggedYet)),
        ),
      );
    }

    final painCounts = {for (var level in Humeur.values) level: 0};

    for (final log in logs) {
      final level = Humeur.values[log.painLevel];
      painCounts[level] = (painCounts[level] ?? 0) + 1;
    }

    final totalDays = logs.length;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.painLevelWidget_painLevelBreakdown,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...Humeur.values.expand(
              (level) => [
                _buildBar(
                  context,
                  label: level.getDisplayName(l10n),
                  count: painCounts[level]!,
                  total: totalDays,
                  color: level.color,
                ),
                if (level != Humeur.values.last) const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
