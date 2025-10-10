import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/models/period_logs/symptom_enum.dart';
import 'package:cycles/models/periods/period.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class DouleursFrequencyWidget extends StatelessWidget {
  final List<PeriodDay> logs;
  final List<Period> periods;

  const DouleursFrequencyWidget({
    super.key,
    required this.logs,
    required this.periods,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    if (logs.isEmpty || periods.isEmpty) {
      return _buildEmptyCard(l10n);
    }

    // 🔹 On trie les cycles du plus ancien au plus récent
    final sortedPeriods = [...periods]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    // 🔹 Comptage total des symptômes (nombre de jours avec ce symptôme)
    final Map<Symptom, int> totalSymptomCounts = {};
    final symptomMap = {for (var s in Symptom.values) s.name: s};

    for (final log in logs) {
      if (log.symptoms != null) {
        for (final symptomString in log.symptoms!) {
          final symptom = symptomMap[symptomString.trim()];
          if (symptom != null) {
            totalSymptomCounts[symptom] =
                (totalSymptomCounts[symptom] ?? 0) + 1;
          }
        }
      }
    }

    // 🔹 Calcul du nombre total de cycles (y compris le cycle en cours)
    final totalCycles = sortedPeriods.length;

    // 🔹 Moyenne par cycle
    final Map<Symptom, double> averageByCycle = {
      for (final entry in totalSymptomCounts.entries)
        entry.key: entry.value / totalCycles,
    };

    // 🔹 Classement du plus fréquent au moins fréquent
    final sortedAverages = averageByCycle.entries
        .sortedBy<num>((e) => e.value)
        .reversed
        .toList();

    if (sortedAverages.isEmpty) {
      return _buildEmptyCard(l10n);
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Titre ---
            Text(
              l10n.symptomFrequencyWidget_mostCommonSymptoms,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // --- Liste des symptômes triés ---
            ...List.generate(sortedAverages.length.clamp(0, 5), (index) {
              final entry = sortedAverages[index];
              final avgDays = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key.getDisplayName(l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      // Ex: "2,3 jours / cycle"
                      '${avgDays.toStringAsFixed(0)} ${l10n.daysPerCycle}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(AppLocalizations l10n) {
    return Card(
      color: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            l10n.symptomFrequencyWidget_noSymptomsLoggedYet,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
