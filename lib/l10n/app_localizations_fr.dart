// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Cycles';

  @override
  String get ongoing => 'En cours';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get start => 'Début';

  @override
  String get end => 'Fin';

  @override
  String get day => 'Jour';

  @override
  String get days => 'Jours';

  @override
  String dayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '$count jour',
    );
    return '$_temp0';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get clear => 'Effacer';

  @override
  String get save => 'Enregistrer';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Confirmer';

  @override
  String get set => 'Définir';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get cancel => 'Annuler';

  @override
  String get select => 'Sélectionner';

  @override
  String get close => 'Fermer';

  @override
  String get flow => 'Flux';

  @override
  String get navBar_insights => 'Analyses';

  @override
  String get navBar_logs => 'Journaux';

  @override
  String get navBar_pill => 'Pilule';

  @override
  String get navBar_settings => 'Paramètres';

  @override
  String get flowIntensity_none => 'Aucun';

  @override
  String get flowIntensity_spotting => 'Légères pertes';

  @override
  String get flowIntensity_light => 'Léger';

  @override
  String get flowIntensity_moderate => 'Modéré';

  @override
  String get flowIntensity_heavy => 'Abondant';

  @override
  String get symptom_headache => 'Maux de tête';

  @override
  String get symptom_fatigue => 'Fatigue';

  @override
  String get symptom_cramps => 'Crampes';

  @override
  String get symptom_nausea => 'Nausées';

  @override
  String get symptom_moodSwings => 'Sautes d’humeur';

  @override
  String get symptom_bloating => 'Ballonnements';

  @override
  String get symptom_acne => 'Acné';

  @override
  String get painLevel_title => 'Niveau de douleur';

  @override
  String get painLevel_none => 'Aucune';

  @override
  String get painLevel_mild => 'Légère';

  @override
  String get painLevel_moderate => 'Modérée';

  @override
  String get painLevel_severe => 'Sévère';

  @override
  String get pain_unbearable => 'Insupportable';

  @override
  String get notification_periodTitle => 'Règles imminentes';

  @override
  String notification_periodBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your next period is estimated to start in $count days.',
      one: 'Your next period is estimated to start in 1 day.',
    );
    return '$_temp0';
  }

  @override
  String get notification_periodOverdueTitle => 'Règles en retard';

  @override
  String notification_periodOverdueBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vos règles ont $count jours de retard.',
      one: 'Vos règles ont 1 jour de retard.',
    );
    return '$_temp0';
  }

  @override
  String get notification_pillTitle => 'Rappel pilule';

  @override
  String get notification_pillBody =>
      'N’oubliez pas de prendre votre pilule aujourd’hui.';

  @override
  String get notification_tamponReminderTitle => 'Rappel tampon';

  @override
  String get notification_tamponReminderBody =>
      'Pensez à changer votre tampon.';

  @override
  String get mainScreen_insightsPageTitle => 'Vos analyses';

  @override
  String get mainScreen_pillsPageTitle => 'Pilules';

  @override
  String get mainScreen_settingsPageTitle => 'Paramètres';

  @override
  String get mainScreen_tooltipSetReminder => 'Rappel tampon';

  @override
  String get mainScreen_tooltipCancelReminder => 'Annuler le rappel';

  @override
  String get mainScreen_tooltipLogPeriod => 'Enregistrer une période';

  @override
  String get insightsScreen_errorPrefix => 'Erreur :';

  @override
  String get insightsScreen_noDataAvailable => 'Aucune donnée disponible.';

  @override
  String get logsScreen_calculatingPrediction => 'Calcul de la prédiction...';

  @override
  String get logScreen_logAtLeastTwoPeriods =>
      'Enregistrez au moins deux périodes pour estimer le prochain cycle.';

  @override
  String get logScreen_nextPeriodEstimate => 'Prochaines règles estimées';

  @override
  String get logScreen_periodDueToday => 'Règles prévues aujourd’hui';

  @override
  String logScreen_periodOverdueBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Règles en retard de $count jours',
      one: 'Règles en retard d’1 jour',
    );
    return '$_temp0';
  }

  @override
  String get logScreen_tamponReminderSetFor => 'Rappel tampon défini pour';

  @override
  String get logScreen_tamponReminderCancelled => 'Rappel tampon annulé.';

  @override
  String get logScreen_couldNotCancelReminder =>
      'Impossible d’annuler le rappel.';

  @override
  String get pillScreen_pillForTodayMarkedAsTaken =>
      'Pilule du jour marquée comme prise.';

  @override
  String get pillScreen_pillForTodayMarkedAsSkipped =>
      'Pilule du jour marquée comme oubliée.';

  @override
  String get settingsScreen_selectHistoryView =>
      'Choisir la vue de l’historique';

  @override
  String get settingsScreen_deleteRegimen_question =>
      'Supprimer le traitement ?';

  @override
  String get settingsScreen_deleteRegimenDescription =>
      'Cela supprimera votre configuration de pilule actuelle et tous les journaux associés. Cette action est irréversible.';

  @override
  String get settingsScreen_allLogsHaveBeenCleared =>
      'Tous les journaux ont été effacés.';

  @override
  String get settingsScreen_clearAllLogs_question =>
      'Effacer tous les journaux ?';

  @override
  String get settingsScreen_deleteAllLogsDescription =>
      'Cela supprimera définitivement tous vos enregistrements de périodes. Les paramètres de l’application ne seront pas affectés.';

  @override
  String get settingsScreen_appearance => 'Apparence';

  @override
  String get settingsScreen_historyViewStyle => 'Style d’historique';

  @override
  String get settingsScreen_appTheme => 'Thème de l’application';

  @override
  String get settingsScreen_themeLight => 'Clair';

  @override
  String get settingsScreen_themeDark => 'Sombre';

  @override
  String get settingsScreen_themeSystem => 'Système';

  @override
  String get settingsScreen_dynamicTheme => 'Thème dynamique';

  @override
  String get settingsScreen_useWallpaperColors =>
      'Utiliser les couleurs du fond d’écran';

  @override
  String get settingsScreen_themeColor => 'Couleur du thème';

  @override
  String get settingsScreen_pickAColor => 'Choisir une couleur';

  @override
  String get settingsScreen_view => 'Vue';

  @override
  String get settingsScreen_birthControl => 'Contraception';

  @override
  String get settingsScreen_setUpPillRegimen => 'Configurer le traitement';

  @override
  String get settingsScreen_trackYourDailyPillIntake =>
      'Suivre la prise quotidienne de la pilule';

  @override
  String get settingsScreen_dailyPillReminder => 'Rappel quotidien de pilule';

  @override
  String get settingsScreen_reminderTime => 'Heure du rappel';

  @override
  String get settingsScreen_periodPredictionAndReminders =>
      'Prédictions et rappels de règles';

  @override
  String get settingsScreen_upcomingPeriodReminder =>
      'Rappel de règles à venir';

  @override
  String get settingsScreen_remindMeBefore => 'Me rappeler avant';

  @override
  String get settingsScreen_notificationTime => 'Heure de notification';

  @override
  String get settingsScreen_overduePeriodReminder =>
      'Rappel de règles en retard';

  @override
  String get settingsScreen_remindMeAfter => 'Me rappeler après';

  @override
  String get settingsScreen_dataManagement => 'Gestion des données';

  @override
  String get settingsScreen_clearAllLogs => 'Effacer tous les journaux';

  @override
  String get settingsScreen_clearAllPillData =>
      'Effacer toutes les données de pilule';

  @override
  String get settingsScreen_clearAllPillData_question =>
      'Effacer toutes les données de pilule ?';

  @override
  String get settingsScreen_deleteAllPillDataDescription =>
      'Cela supprimera définitivement votre traitement, vos rappels et votre historique. Cette action est irréversible.';

  @override
  String get settingsScreen_allPillDataCleared =>
      'Toutes les données de pilule ont été effacées.';

  @override
  String get settingsScreen_dangerZone => 'Zone à risque';

  @override
  String get settingsScreen_clearAllLogsSubtitle =>
      'Supprime tout votre historique de règles et de symptômes.';

  @override
  String get settingsScreen_clearAllPillDataSubtitle =>
      'Supprime votre traitement et l’historique des prises.';

  @override
  String get settingsScreen_security => 'Sécurité';

  @override
  String get securityScreen_enableBiometricLock =>
      'Activer le verrouillage biométrique';

  @override
  String get securityScreen_enableBiometricLockSubtitle =>
      'Exiger une empreinte digitale ou la reconnaissance faciale pour ouvrir l’application.';

  @override
  String get securityScreen_noBiometricsAvailable =>
      'Aucun code, empreinte ou reconnaissance faciale détecté. Veuillez en configurer un dans les paramètres de votre appareil.';

  @override
  String get settingsScreen_preferences => 'Préférences';

  @override
  String get preferencesScreen_tamponReminderButton =>
      'Afficher toujours le bouton de rappel';

  @override
  String get preferencesScreen_tamponReminderButtonSubtitle =>
      'Affiche en permanence le bouton de rappel tampon sur l’écran principal.';

  @override
  String get settingsScreen_about => 'À propos';

  @override
  String get aboutScreen_version => 'Version';

  @override
  String get aboutScreen_github => 'GitHub';

  @override
  String get aboutScreen_githubSubtitle => 'Code source et suivi des problèmes';

  @override
  String get aboutScreen_share => 'Partager';

  @override
  String get aboutScreen_shareSubtitle =>
      'Partager l’application avec des amis';

  @override
  String get aboutScreen_urlError => 'Impossible d’ouvrir le lien.';

  @override
  String get tamponReminderDialog_tamponReminderTitle => 'Rappel tampon';

  @override
  String get tamponReminderDialog_tamponReminderMaxDuration =>
      'Durée maximale : 8 heures.';

  @override
  String get reminderCountdownDialog_title => 'Rappel dans';

  @override
  String reminderCountdownDialog_dueAt(Object time) {
    return 'Prévu à $time';
  }

  @override
  String get cycleLengthVarianceWidget_LogAtLeastTwoPeriods =>
      'Au moins deux cycles sont nécessaires pour afficher la variance.';

  @override
  String get cycleLengthVarianceWidget_cycleAndPeriodVeriance =>
      'Variance du cycle et de la période';

  @override
  String get cycleLengthVarianceWidget_averageCycle => 'Cycle moyen';

  @override
  String get cycleLengthVarianceWidget_averagePeriod => 'Période moyenne';

  @override
  String get cycleLengthVarianceWidget_period => 'Période';

  @override
  String get cycleLengthVarianceWidget_cycle => 'Cycle';

  @override
  String get flowIntensityWidget_flowIntensityBreakdown =>
      'Répartition de l’intensité du flux';

  @override
  String get flowIntensityWidget_noFlowDataLoggedYet =>
      'Aucune donnée de flux enregistrée pour le moment.';

  @override
  String get painLevelWidget_noPainDataLoggedYet =>
      'Aucune donnée de douleur enregistrée pour le moment.';

  @override
  String get painLevelWidget_painLevelBreakdown =>
      'Répartition des niveaux de douleur';

  @override
  String get monthlyFlowChartWidget_noDataToDisplay =>
      'Aucune donnée à afficher.';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatterns =>
      'Schémas de flux menstruel';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatternsDescription =>
      'Chaque ligne représente un cycle complet';

  @override
  String get symptomFrequencyWidget_noSymptomsLoggedYet =>
      'Aucun symptôme enregistré pour le moment.';

  @override
  String get symptomFrequencyWidget_mostCommonSymptoms =>
      'Symptômes les plus fréquents';

  @override
  String get yearHeatMapWidget_yearlyOverview => 'Vue d’ensemble annuelle';

  @override
  String get journalViewWidget_logYourFirstPeriod =>
      'Enregistrez votre première période.';

  @override
  String get listViewWidget_noPeriodsLogged =>
      'Aucune période enregistrée.\nAppuyez sur le bouton + pour en ajouter une.';

  @override
  String get listViewWidget_confirmDelete => 'Confirmer la suppression';

  @override
  String get listViewWidget_confirmDeleteDescription =>
      'Voulez-vous vraiment supprimer cette entrée ?';

  @override
  String get emptyPillStateWidget_noPillRegimenFound =>
      'Aucun traitement trouvé.';

  @override
  String get emptyPillStateWidget_noPillRegimenFoundDescription =>
      'Configurez votre traitement dans les paramètres pour commencer le suivi.';

  @override
  String get pillPackVisualiser_yourPack => 'Votre plaquette';

  @override
  String pillStatus_pillsOfTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sur $count pilules',
      one: 'sur 1 pilule',
    );
    return '$_temp0';
  }

  @override
  String get pillStatus_undo => 'Annuler';

  @override
  String get pillStatus_skip => 'Ignorer';

  @override
  String get pillStatus_markAsTaken => 'Marquer comme prise';

  @override
  String get regimenSetupWidget_setUpPillRegimen => 'Configurer le traitement';

  @override
  String get regimenSetupWidget_packName => 'Nom de la plaquette';

  @override
  String get regimenSetupWidget_pleaseEnterAName => 'Veuillez saisir un nom';

  @override
  String get regimenSetupWidget_activePills => 'Pilules actives';

  @override
  String get regimenSetupWidget_enterANumber => 'Saisissez un nombre';

  @override
  String get regimenSetupWidget_placeboPills => 'Pilules placebo';

  @override
  String get regimenSetupWidget_firstDayOfThisPack =>
      'Premier jour de cette plaquette';

  @override
  String get symptomEntrySheet_logYourDay => 'Enregistrez votre journée';

  @override
  String get symptomEntrySheet_symptomsOptional => 'Symptômes (optionnel)';

  @override
  String get periodDetailsSheet_symptoms => 'Symptômes';

  @override
  String get periodDetailsSheet_flow => 'Flux';

  @override
  String periodPredictionCircle_days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'jours',
      one: 'jour',
    );
    return '$_temp0';
  }
}
