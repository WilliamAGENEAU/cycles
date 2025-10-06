import 'package:cycles/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum FlowRate {
  none,
  legers,
  moderes,
  abondants,
  tresAbondants;

  /// Returns flow rates that represent an actual flow during a period.
  static List<FlowRate> get periodFlows =>
      values.where((flow) => flow != FlowRate.none).toList();
}

extension FlowExtension on FlowRate {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case FlowRate.none:
        return l10n.flowIntensity_none;
      case FlowRate.legers:
        return l10n.flowIntensity_spotting;
      case FlowRate.moderes:
        return l10n.flowIntensity_light;
      case FlowRate.abondants:
        return l10n.flowIntensity_moderate;
      case FlowRate.tresAbondants:
        return l10n.flowIntensity_heavy;
    }
  }

  int get intValue {
    return index;
  }

  String get svgAsset {
    switch (this) {
      case FlowRate.none:
        return 'assets/icons/none.svg';
      case FlowRate.legers:
        return 'assets/icons/light.svg';
      case FlowRate.moderes:
        return 'assets/icons/light2.svg';
      case FlowRate.abondants:
        return 'assets/icons/medium.svg';
      case FlowRate.tresAbondants:
        return 'assets/icons/heavy.svg';
    }
  }

  Color getColor(BuildContext context, bool isSelected) {
    final base = switch (this) {
      FlowRate.none => Colors.blue.shade300,
      FlowRate.legers => Colors.pink.shade100,
      FlowRate.moderes => Colors.pink.shade200,
      FlowRate.abondants => Colors.pink.shade400,
      FlowRate.tresAbondants => Colors.red.shade600,
    };
    return isSelected
        ? base
        : Theme.of(context).colorScheme.surfaceContainerHighest;
  }

  Color get color {
    switch (this) {
      case FlowRate.none:
        return Colors.blue.shade300;
      case FlowRate.legers:
        return Colors.pink.shade100;
      case FlowRate.moderes:
        return Colors.pink.shade200;
      case FlowRate.abondants:
        return Colors.pink.shade400;
      case FlowRate.tresAbondants:
        return Colors.red.shade600;
    }
  }
}
