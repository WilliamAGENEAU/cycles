// ignore_for_file: deprecated_member_use

import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/flows/flow_enum.dart';
import 'package:cycles/models/period_logs/humeur_level_enum.dart';
import 'package:cycles/models/period_logs/symptom_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  Humeur _painLevel = Humeur.none;
  double? _temperature; // 🔹 Ajout du champ température

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- Title ---
            Center(
              child: Text(
                l10n.symptomEntrySheet_logYourDay,
                style: theme.textTheme.titleLarge,
              ),
            ),

            // --- Date Picker ---
            const SizedBox(height: 24),
            Text(l10n.date, style: theme.textTheme.bodySmall),
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

            const SizedBox(height: 16),

            // --- 🔹 Température ---
            Text(l10n.temperature, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            SizedBox(
              width: double
                  .infinity, // <-- pour que le TextFormField prenne toute la largeur
              child: TextFormField(
                initialValue: _temperature != null
                    ? _temperature!.toStringAsFixed(1)
                    : '',
                textAlign: TextAlign.start,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  suffixText: '°C',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _temperature = double.tryParse(value.replaceAll(',', '.'));
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // --- Flow Selection ---
            Text(l10n.flow, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: FlowRate.periodFlows.map((flow) {
                  final bool isSelected = _flowSelection == flow;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _flowSelection = flow);
                    },
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: flow.getColor(context, isSelected),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: flow
                                          .getColor(context, true)
                                          .withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            flow.svgAsset,
                            colorFilter: ColorFilter.mode(
                              isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          flow.getDisplayName(l10n),
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // --- Pain Level ---
            Text(
              '${l10n.painLevel_title}: ${_painLevel.getDisplayName(l10n)}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: Humeur.values.map((painLevel) {
                final bool isSelected = _painLevel == painLevel;
                return IconButton(
                  icon: Icon(painLevel.icon),
                  iconSize: 36,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  onPressed: () {
                    setState(() {
                      _painLevel = painLevel;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // --- Symptoms ---
            Text(
              l10n.symptomEntrySheet_symptomsOptional,
              style: theme.textTheme.bodySmall,
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
                        'temperature':
                            _temperature, // 🔹 on renvoie la température
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
