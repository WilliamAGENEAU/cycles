import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/flows/flow_enum.dart';
import 'package:cycles/models/period_logs/pain_level_enum.dart';
import 'package:cycles/models/period_logs/symptom_enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SymptomEntrySheet extends StatefulWidget {
  const SymptomEntrySheet({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  State<SymptomEntrySheet> createState() => _SymptomEntrySheetState();
}

class _SymptomEntrySheetState extends State<SymptomEntrySheet> {
  late DateTime _selectedDate;
  final Set<Symptom> _selectedSymptoms = {};
  FlowRate _flowSelection = FlowRate.none;
  PainLevel _painLevel = PainLevel.none;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Drag Handle ---
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // --- Title ---
            Center(
              child: Text(
                l10n.symptomEntrySheet_logYourDay,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // --- Date Picker ---
            const SizedBox(height: 24),
            Text(l10n.date, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(
                DateFormat('EEEE, d MMMM yyyy').format(_selectedDate),
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                alignment: Alignment.centerLeft,
              ),
              onPressed: _pickDate,
            ),
            const SizedBox(height: 8),
            // --- Flow Selection ---
            Text(l10n.flow, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: FlowRate.periodFlows.map((flow) {
                return ChoiceChip(
                  label: Text(flow.getDisplayName(l10n)),
                  selected: _flowSelection == flow,
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        _flowSelection = flow;
                      } else {
                        _flowSelection = FlowRate.none;
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // --- Pain Level ---
            Text(
              '${l10n.painLevel_title}: ${_painLevel.getDisplayName(l10n)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: PainLevel.values.map((painLevel) {
                    final bool isSelected = _painLevel == painLevel;

                    return IconButton(
                      icon: Icon(painLevel.icon),
                      iconSize: 36,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      onPressed: () {
                        setState(() {
                          _painLevel = painLevel;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // --- Symptoms ---
            Text(
              l10n.symptomEntrySheet_symptomsOptional,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: Symptom.values.map((symptom) {
                return FilterChip(
                  label: Text(symptom.getDisplayName(l10n)),
                  selected: _selectedSymptoms.contains(symptom),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedSymptoms.add(symptom);
                      } else {
                        _selectedSymptoms.remove(symptom);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // --- Action Buttons ---
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      final symptomsToSave = _selectedSymptoms
                          .map((s) => s.name)
                          .toList();

                      Navigator.of(context).pop({
                        'date': _selectedDate,
                        'flow': _flowSelection,
                        'symptoms': symptomsToSave,
                        'painLevel': _painLevel.intValue,
                      });
                    },
                    child: Text(l10n.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
