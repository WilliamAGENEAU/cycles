import 'package:cycles/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum PainLevel { none, mild, moderate, severe, unbearable }

extension FlowExtension on PainLevel {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case PainLevel.none:
        return l10n.painLevel_none;
      case PainLevel.mild:
        return l10n.painLevel_mild;
      case PainLevel.moderate:
        return l10n.painLevel_moderate;
      case PainLevel.severe:
        return l10n.painLevel_severe;
      case PainLevel.unbearable:
        return l10n.pain_unbearable;
    }
  }

  int get intValue {
    return index;
  }

  IconData get icon {
    switch (this) {
      case PainLevel.none:
        return Icons.sentiment_very_satisfied_outlined;
      case PainLevel.mild:
        return Icons.sentiment_satisfied_outlined;
      case PainLevel.moderate:
        return Icons.sentiment_neutral_outlined;
      case PainLevel.severe:
        return Icons.sentiment_dissatisfied_outlined;
      case PainLevel.unbearable:
        return Icons.sentiment_very_dissatisfied_outlined;
    }
  }

  Color get color {
    switch (this) {
      case PainLevel.none:
        return Colors.blue.shade300;
      case PainLevel.mild:
        return Colors.teal.shade300;
      case PainLevel.moderate:
        return Colors.amber.shade400;
      case PainLevel.severe:
        return Colors.red.shade400;
      case PainLevel.unbearable:
        return Colors.purple.shade300;
    }
  }
}
