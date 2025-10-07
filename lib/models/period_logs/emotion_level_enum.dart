import 'package:cycles/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum Emotion {
  none,
  anxieuse,
  colere,
  triste,
  heureuse,
  bien,
  sensible,
  fatiguee,
}

extension EmotionExtension on Emotion {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case Emotion.none:
        return l10n.emotion_aucun;
      case Emotion.heureuse:
        return l10n.emotion_heureuse;
      case Emotion.bien:
        return l10n.emotion_bien;
      case Emotion.fatiguee:
        return l10n.emotion_fatiguee;
      case Emotion.anxieuse:
        return l10n.emotion_anxieuse;
      case Emotion.colere:
        return l10n.emotion_colere;
      case Emotion.triste:
        return l10n.emotion_triste;
      case Emotion.sensible:
        return l10n.emotion_sensible;
    }
  }

  int get intValue {
    return index;
  }

  IconData get icon {
    switch (this) {
      case Emotion.none:
        return Icons.sentiment_neutral_outlined;
      case Emotion.anxieuse:
        return Icons.sentiment_very_dissatisfied_outlined;
      case Emotion.colere:
        return Icons.sentiment_dissatisfied_outlined;
      case Emotion.triste:
        return Icons.mood_bad_outlined;
      case Emotion.heureuse:
        return Icons.sentiment_very_satisfied_outlined;
      case Emotion.bien:
        return Icons.sentiment_satisfied_outlined;
      case Emotion.sensible:
        return Icons.face_outlined;
      case Emotion.fatiguee:
        return Icons.bedtime_outlined;
    }
  }

  Color get color {
    switch (this) {
      case Emotion.none:
        return Colors.blue.shade300;
      case Emotion.anxieuse:
        return Colors.teal.shade300;
      case Emotion.colere:
        return Colors.amber.shade400;
      case Emotion.triste:
        return Colors.red.shade400;
      case Emotion.heureuse:
        return Colors.purple.shade300;
      case Emotion.bien:
        return Colors.green.shade400;
      case Emotion.sensible:
        return Colors.orange.shade400;
      case Emotion.fatiguee:
        return Colors.brown.shade400;
    }
  }
}
