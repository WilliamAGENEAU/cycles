import 'package:cycles/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum Humeur { none, anxieux, irritable, triste, joyeux }

extension FlowExtension on Humeur {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case Humeur.none:
        return l10n.painLevel_none;
      case Humeur.anxieux:
        return l10n.painLevel_mild;
      case Humeur.irritable:
        return l10n.painLevel_moderate;
      case Humeur.triste:
        return l10n.painLevel_severe;
      case Humeur.joyeux:
        return l10n.pain_unbearable;
    }
  }

  int get intValue {
    return index;
  }

  IconData get icon {
    switch (this) {
      case Humeur.none:
        return Icons.sentiment_neutral_outlined;
      case Humeur.anxieux:
        return Icons.sentiment_very_dissatisfied_outlined;
      case Humeur.irritable:
        return Icons.sentiment_dissatisfied_outlined;
      case Humeur.triste:
        return Icons.mood_bad_outlined;
      case Humeur.joyeux:
        return Icons.sentiment_very_satisfied_outlined;
    }
  }

  Color get color {
    switch (this) {
      case Humeur.none:
        return Colors.blue.shade300;
      case Humeur.anxieux:
        return Colors.teal.shade300;
      case Humeur.irritable:
        return Colors.amber.shade400;
      case Humeur.triste:
        return Colors.red.shade400;
      case Humeur.joyeux:
        return Colors.purple.shade300;
    }
  }
}
