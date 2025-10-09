import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/models/period_logs/symptom_enum.dart';
import 'package:cycles/models/periods/period.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class DouleursFrequencyWidget extends StatefulWidget {
  final List<PeriodDay> logs;
  final List<Period> periods;

  const DouleursFrequencyWidget({
    super.key,
    required this.logs,
    required this.periods,
  });

  @override
  State<DouleursFrequencyWidget> createState() =>
      _DouleursFrequencyWidgetState();
}

class _DouleursFrequencyWidgetState extends State<DouleursFrequencyWidget> {
  int _currentCycleIndex = 0;

  @override
  void initState() {
    super.initState();
    // Trie les cycles du plus récent au plus ancien
    widget.periods.sort((a, b) => b.startDate.compareTo(a.startDate));

    // Sélectionne le cycle actuel par défaut
    final now = DateTime.now();
    final current = widget.periods.indexWhere(
      (p) =>
          now.isAfter(p.startDate) &&
          now.isBefore(p.endDate.add(const Duration(days: 1))),
    );
    _currentCycleIndex = current != -1 ? current : 0;
  }

  void _goToPreviousCycle() {
    if (_currentCycleIndex < widget.periods.length - 1) {
      setState(() {
        _currentCycleIndex++;
      });
    }
  }

  void _goToNextCycle() {
    if (_currentCycleIndex > 0) {
      setState(() {
        _currentCycleIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    if (widget.periods.isEmpty) {
      return _buildEmptyCard(l10n);
    }

    final sortedPeriods = [...widget.periods]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final currentCycle = sortedPeriods[_currentCycleIndex];

    // Détermination de la fin réelle du cycle
    DateTime cycleStart = currentCycle.startDate;
    DateTime cycleEnd;

    if (_currentCycleIndex < sortedPeriods.length - 1) {
      // Fin = veille du cycle suivant
      cycleEnd = sortedPeriods[_currentCycleIndex + 1].startDate.subtract(
        const Duration(days: 1),
      );
    } else {
      // Cycle actuel → jusqu’à aujourd’hui
      cycleEnd = DateTime.now();
    }

    // On filtre les logs du cycle complet
    final cycleLogs = widget.logs
        .where(
          (log) =>
              !log.date.isBefore(cycleStart) && !log.date.isAfter(cycleEnd),
        )
        .toList();

    // Comptage des douleurs
    final Map<Symptom, int> symptomCounts = {};
    final symptomMap = {for (var s in Symptom.values) s.name: s};

    for (final log in cycleLogs) {
      if (log.symptoms != null) {
        for (final symptomString in log.symptoms!) {
          final symptom = symptomMap[symptomString.trim()];
          if (symptom != null) {
            symptomCounts[symptom] = (symptomCounts[symptom] ?? 0) + 1;
          }
        }
      }
    }

    final sortedSymptoms = symptomCounts.entries
        .sortedBy<num>((e) => e.value)
        .reversed
        .toList();

    final dateFormat = DateFormat('dd/MM');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- En-tête navigation ---
            Text(
              l10n.symptomFrequencyWidget_mostCommonSymptoms,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _currentCycleIndex < sortedPeriods.length - 1
                      ? _goToPreviousCycle
                      : null,
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Cycle du ${dateFormat.format(cycleStart)} au ${dateFormat.format(cycleEnd)}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _currentCycleIndex > 0 ? _goToNextCycle : null,
                  icon: const Icon(
                    Icons.chevron_right,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (sortedSymptoms.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    l10n.symptomFrequencyWidget_noSymptomsLoggedYet,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              )
            else
              ...List.generate(sortedSymptoms.length.clamp(0, 5), (index) {
                final entry = sortedSymptoms[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key.getDisplayName(l10n),
                          maxLines: 1,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.dayCount(entry.value),
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
