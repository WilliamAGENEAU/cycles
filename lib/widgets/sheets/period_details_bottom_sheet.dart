// ignore_for_file: deprecated_member_use

import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/flows/flow_enum.dart';
import 'package:cycles/models/period_logs/humeur_level_enum.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/models/period_logs/symptom_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PeriodDetailsBottomSheet extends StatefulWidget {
  final PeriodDay log;
  final VoidCallback onDelete;
  final void Function(PeriodDay) onSave;

  const PeriodDetailsBottomSheet({
    super.key,
    required this.log,
    required this.onDelete,
    required this.onSave,
  });

  @override
  State<PeriodDetailsBottomSheet> createState() =>
      _PeriodDetailsBottomSheetState();
}

class _PeriodDetailsBottomSheetState extends State<PeriodDetailsBottomSheet> {
  bool _isEditing = false;

  late FlowRate _editedFlow;
  late Humeur _editedPainLevel;
  late List<Symptom> _editedSymptoms;
  final List<Symptom> _allSymptoms = Symptom.values;
  double? _editedTemperature; // Pour stocker la valeur en édition

  @override
  void initState() {
    super.initState();
    _resetEditableState();
  }

  void _resetEditableState() {
    _editedFlow = widget.log.flow;
    _editedPainLevel = Humeur.values[widget.log.painLevel];
    _editedSymptoms =
        widget.log.symptoms
            ?.map((symptomString) {
              try {
                return Symptom.values.firstWhere(
                  (e) => e.name == symptomString,
                );
              } catch (e) {
                return null;
              }
            })
            .whereType<Symptom>()
            .toList() ??
        [];

    // 🔹 Initialisation de la température
    _editedTemperature = widget.log.temperature;
  }

  void _handleSave() {
    final symptomsToSave = _editedSymptoms.map((s) => s.name).toList();
    final updatedLog = widget.log.copyWith(
      flow: _editedFlow,
      painLevel: _editedPainLevel.intValue,
      symptoms: symptomsToSave,
      temperature: _editedTemperature, // 🔹 on sauvegarde la température
    );

    widget.onSave(updatedLog);

    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (_isEditing ? 0.6 : 0.4),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 12),
          _buildHeader(context),
          const Divider(height: 24),
          _buildTemperatureSection(context),
          const SizedBox(height: 16),
          _buildFlowSection(context),
          const SizedBox(height: 16),
          _buildPainLevelSection(context),
          const SizedBox(height: 16),
          _buildSymptomsSection(context),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('EEEE d MMMM', 'fr_FR').format(widget.log.date),
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (_isEditing)
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurface),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    _resetEditableState();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.check, color: colorScheme.primary),
                onPressed: _handleSave,
              ),
            ],
          )
        else
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined, color: colorScheme.onSurface),
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 24,
                  color: colorScheme.error,
                ),
                onPressed: () {
                  widget.onDelete();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFlowSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isEditing) {
      final flow = widget.log.flow;

      return Row(
        children: [
          Icon(Icons.opacity, color: colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Text('${l10n.periodDetailsSheet_flow}: ', style: textTheme.bodyLarge),
          Text(
            flow.getDisplayName(l10n),
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ...List.generate(
            4,
            (index) => Icon(
              flow != FlowRate.none && index < flow.intValue
                  ? Icons.water_drop
                  : Icons.water_drop_outlined,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
        ],
      );
    } else {
      // --- Mode édition avec icônes SVG modernes ---
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${l10n.periodDetailsSheet_flow}:', style: textTheme.bodyLarge),
          const SizedBox(height: 8),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: FlowRate.periodFlows.map((flow) {
                final bool isSelected = _editedFlow == flow;
                return GestureDetector(
                  onTap: () {
                    setState(() => _editedFlow = flow);
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
                                : colorScheme.onSurfaceVariant,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        flow.getDisplayName(l10n),
                        style: textTheme.bodySmall!.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildTemperatureSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isEditing) {
      // 🔹 Affichage en mode lecture
      final temperature = widget.log.temperature;

      if (temperature == null) {
        return Row(
          children: [
            Icon(
              Icons.thermostat,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text('${l10n.temperature}:', style: textTheme.bodyLarge),
            const SizedBox(width: 8),
            Text(
              l10n.noDataAvailable, // ou "—" si tu veux afficher un tiret
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.thermostat, color: colorScheme.onSurfaceVariant, size: 22),
          const SizedBox(width: 12),
          Text('${l10n.temperature}: ', style: textTheme.bodyLarge),
          Text(
            '${temperature.toStringAsFixed(1)} °C',
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      // 🔹 Mode édition (saisie manuelle)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.temperature,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double
                .infinity, // <-- pour que le TextFormField prenne toute la largeur
            child: TextFormField(
              initialValue: _editedTemperature != null
                  ? _editedTemperature!.toStringAsFixed(1)
                  : '',
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                suffixText: '°C',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: '36.8',
              ),
              onChanged: (value) {
                setState(() {
                  _editedTemperature = double.tryParse(
                    value.replaceAll(',', '.'),
                  );
                });
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPainLevelSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isEditing) {
      final painLevel = Humeur.values[widget.log.painLevel];

      return Row(
        children: [
          Icon(painLevel.icon, color: colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Text('${l10n.painLevel_title}: ', style: textTheme.bodyLarge),
          Text(
            painLevel.getDisplayName(l10n),
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.painLevel_title}: ${_editedPainLevel.getDisplayName(l10n)}',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Humeur.values.map((painLevel) {
              final bool isSelected = _editedPainLevel == painLevel;

              return IconButton(
                icon: Icon(painLevel.icon),
                iconSize: 36,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                onPressed: () {
                  setState(() {
                    _editedPainLevel = painLevel;
                  });
                },
              );
            }).toList(),
          ),
        ],
      );
    }
  }

  Widget _buildSymptomsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final header = Row(
      children: [
        Icon(
          Icons.bubble_chart_outlined,
          color: colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          '${l10n.periodDetailsSheet_symptoms}:',
          style: textTheme.bodyLarge,
        ),
      ],
    );

    if (!_isEditing) {
      if (_editedSymptoms.isEmpty) {
        return const SizedBox.shrink();
      }

      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _editedSymptoms.map((symptom) {
                    return Chip(label: Text(symptom.getDisplayName(l10n)));
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // --- EDIT MODE ---
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _allSymptoms.map((symptom) {
                    return FilterChip(
                      label: Text(symptom.getDisplayName(l10n)),
                      selected: _editedSymptoms.contains(symptom),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            _editedSymptoms.add(symptom);
                          } else {
                            _editedSymptoms.remove(symptom);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
