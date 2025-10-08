import 'package:cycles/l10n/app_localizations.dart';

enum Symptom {
  tete,
  dos,
  reins,
  crampes,
  poitrine,
  brulure,
  ballonement,
  nause,
  acne,
  diarrhe,
  constipation,
  vuvlaire,
}

extension SymptomExtension on Symptom {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case Symptom.tete:
        return l10n.symptom_headache;
      case Symptom.dos:
        return l10n.symptom_dos;
      case Symptom.reins:
        return l10n.symptom_reins;
      case Symptom.crampes:
        return l10n.symptom_cramps;
      case Symptom.poitrine:
        return l10n.symptom_poitrine;
      case Symptom.brulure:
        return l10n.symptom_brulure;
      case Symptom.ballonement:
        return l10n.symptom_ballonement;
      case Symptom.nause:
        return l10n.symptom_nausea;
      case Symptom.acne:
        return l10n.symptom_acne;
      case Symptom.diarrhe:
        return l10n.symptom_diarrhea;
      case Symptom.constipation:
        return l10n.symptom_constipation;
      case Symptom.vuvlaire:
        return l10n.symptom_vulvar;
    }
  }
}
