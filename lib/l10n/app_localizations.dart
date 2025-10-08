import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Cycles'**
  String get appTitle;

  /// No description provided for @ongoing.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get ongoing;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In fr, this message translates to:
  /// **'Heure'**
  String get time;

  /// No description provided for @start.
  ///
  /// In fr, this message translates to:
  /// **'Début'**
  String get start;

  /// No description provided for @end.
  ///
  /// In fr, this message translates to:
  /// **'Fin'**
  String get end;

  /// No description provided for @day.
  ///
  /// In fr, this message translates to:
  /// **'Jour'**
  String get day;

  /// No description provided for @days.
  ///
  /// In fr, this message translates to:
  /// **'Jours'**
  String get days;

  /// Affiche le nombre de jours, en gérant le singulier et le pluriel.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} jour} other{{count} jours}}'**
  String dayCount(int count);

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @clear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get clear;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @ok.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @set.
  ///
  /// In fr, this message translates to:
  /// **'Définir'**
  String get set;

  /// No description provided for @yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get no;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @select.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner'**
  String get select;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @flow.
  ///
  /// In fr, this message translates to:
  /// **'Flux'**
  String get flow;

  /// No description provided for @navBar_insights.
  ///
  /// In fr, this message translates to:
  /// **'Analyses'**
  String get navBar_insights;

  /// No description provided for @navBar_logs.
  ///
  /// In fr, this message translates to:
  /// **'Journaux'**
  String get navBar_logs;

  /// No description provided for @navBar_pill.
  ///
  /// In fr, this message translates to:
  /// **'Pilule'**
  String get navBar_pill;

  /// No description provided for @navBar_settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get navBar_settings;

  /// No description provided for @flowIntensity_none.
  ///
  /// In fr, this message translates to:
  /// **'Aucun'**
  String get flowIntensity_none;

  /// No description provided for @flowIntensity_spotting.
  ///
  /// In fr, this message translates to:
  /// **'Légers'**
  String get flowIntensity_spotting;

  /// No description provided for @flowIntensity_light.
  ///
  /// In fr, this message translates to:
  /// **'Modérés'**
  String get flowIntensity_light;

  /// No description provided for @flowIntensity_moderate.
  ///
  /// In fr, this message translates to:
  /// **'Abondants'**
  String get flowIntensity_moderate;

  /// No description provided for @flowIntensity_heavy.
  ///
  /// In fr, this message translates to:
  /// **'Très abondants'**
  String get flowIntensity_heavy;

  /// No description provided for @symptom_headache.
  ///
  /// In fr, this message translates to:
  /// **'Maux de tête'**
  String get symptom_headache;

  /// No description provided for @symptom_fatigue.
  ///
  /// In fr, this message translates to:
  /// **'Fatigue'**
  String get symptom_fatigue;

  /// No description provided for @symptom_cramps.
  ///
  /// In fr, this message translates to:
  /// **'Crampes'**
  String get symptom_cramps;

  /// No description provided for @symptom_nausea.
  ///
  /// In fr, this message translates to:
  /// **'Nausées'**
  String get symptom_nausea;

  /// No description provided for @symptom_moodSwings.
  ///
  /// In fr, this message translates to:
  /// **'Sautes d’humeur'**
  String get symptom_moodSwings;

  /// No description provided for @symptom_bloating.
  ///
  /// In fr, this message translates to:
  /// **'Ballonnements'**
  String get symptom_bloating;

  /// No description provided for @symptom_acne.
  ///
  /// In fr, this message translates to:
  /// **'Acné'**
  String get symptom_acne;

  /// No description provided for @painLevel_title.
  ///
  /// In fr, this message translates to:
  /// **'Émotions'**
  String get painLevel_title;

  /// No description provided for @emotion_aucun.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get emotion_aucun;

  /// No description provided for @emotion_anxieuse.
  ///
  /// In fr, this message translates to:
  /// **'Anxieuse'**
  String get emotion_anxieuse;

  /// No description provided for @emotion_colere.
  ///
  /// In fr, this message translates to:
  /// **'Colère'**
  String get emotion_colere;

  /// No description provided for @emotion_triste.
  ///
  /// In fr, this message translates to:
  /// **'Triste'**
  String get emotion_triste;

  /// No description provided for @emotion_heureuse.
  ///
  /// In fr, this message translates to:
  /// **'Heureuse'**
  String get emotion_heureuse;

  /// No description provided for @emotion_bien.
  ///
  /// In fr, this message translates to:
  /// **'Bien'**
  String get emotion_bien;

  /// No description provided for @emotion_sensible.
  ///
  /// In fr, this message translates to:
  /// **'Sensible'**
  String get emotion_sensible;

  /// No description provided for @emotion_fatiguee.
  ///
  /// In fr, this message translates to:
  /// **'Fatiguée'**
  String get emotion_fatiguee;

  /// No description provided for @notification_periodTitle.
  ///
  /// In fr, this message translates to:
  /// **'Règles imminentes'**
  String get notification_periodTitle;

  /// Body for the upcoming period notification.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Your next period is estimated to start in 1 day.} other{Your next period is estimated to start in {count} days.}}'**
  String notification_periodBody(int count);

  /// No description provided for @notification_periodOverdueTitle.
  ///
  /// In fr, this message translates to:
  /// **'Règles en retard'**
  String get notification_periodOverdueTitle;

  /// Body for the overdue period notification.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Vos règles ont 1 jour de retard.} other{Vos règles ont {count} jours de retard.}}'**
  String notification_periodOverdueBody(int count);

  /// No description provided for @notification_pillTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappel pilule'**
  String get notification_pillTitle;

  /// No description provided for @notification_pillBody.
  ///
  /// In fr, this message translates to:
  /// **'N’oubliez pas de prendre votre pilule aujourd’hui.'**
  String get notification_pillBody;

  /// No description provided for @notification_tamponReminderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappel tampon'**
  String get notification_tamponReminderTitle;

  /// No description provided for @notification_tamponReminderBody.
  ///
  /// In fr, this message translates to:
  /// **'Pensez à changer votre tampon.'**
  String get notification_tamponReminderBody;

  /// No description provided for @mainScreen_insightsPageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos analyses'**
  String get mainScreen_insightsPageTitle;

  /// No description provided for @mainScreen_pillsPageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pilules'**
  String get mainScreen_pillsPageTitle;

  /// No description provided for @mainScreen_settingsPageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get mainScreen_settingsPageTitle;

  /// No description provided for @mainScreen_tooltipSetReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel tampon'**
  String get mainScreen_tooltipSetReminder;

  /// No description provided for @mainScreen_tooltipCancelReminder.
  ///
  /// In fr, this message translates to:
  /// **'Annuler le rappel'**
  String get mainScreen_tooltipCancelReminder;

  /// No description provided for @mainScreen_tooltipLogPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer une période'**
  String get mainScreen_tooltipLogPeriod;

  /// No description provided for @insightsScreen_errorPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Erreur :'**
  String get insightsScreen_errorPrefix;

  /// No description provided for @insightsScreen_noDataAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée disponible.'**
  String get insightsScreen_noDataAvailable;

  /// No description provided for @logsScreen_calculatingPrediction.
  ///
  /// In fr, this message translates to:
  /// **'Calcul de la prédiction...'**
  String get logsScreen_calculatingPrediction;

  /// No description provided for @logScreen_logAtLeastTwoPeriods.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez au moins deux périodes pour estimer le prochain cycle.'**
  String get logScreen_logAtLeastTwoPeriods;

  /// No description provided for @logScreen_nextPeriodEstimate.
  ///
  /// In fr, this message translates to:
  /// **'Prochaines règles estimées'**
  String get logScreen_nextPeriodEstimate;

  /// No description provided for @logScreen_periodDueToday.
  ///
  /// In fr, this message translates to:
  /// **'Règles prévues aujourd’hui'**
  String get logScreen_periodDueToday;

  /// A label showing the total number of days period is overdue.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Règles en retard d’1 jour} other{Règles en retard de {count} jours}}'**
  String logScreen_periodOverdueBy(int count);

  /// No description provided for @logScreen_tamponReminderSetFor.
  ///
  /// In fr, this message translates to:
  /// **'Rappel tampon défini pour'**
  String get logScreen_tamponReminderSetFor;

  /// No description provided for @logScreen_tamponReminderCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Rappel tampon annulé.'**
  String get logScreen_tamponReminderCancelled;

  /// No description provided for @logScreen_couldNotCancelReminder.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’annuler le rappel.'**
  String get logScreen_couldNotCancelReminder;

  /// No description provided for @pillScreen_pillForTodayMarkedAsTaken.
  ///
  /// In fr, this message translates to:
  /// **'Pilule du jour marquée comme prise.'**
  String get pillScreen_pillForTodayMarkedAsTaken;

  /// No description provided for @pillScreen_pillForTodayMarkedAsSkipped.
  ///
  /// In fr, this message translates to:
  /// **'Pilule du jour marquée comme oubliée.'**
  String get pillScreen_pillForTodayMarkedAsSkipped;

  /// No description provided for @settingsScreen_selectHistoryView.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la vue de l’historique'**
  String get settingsScreen_selectHistoryView;

  /// No description provided for @settingsScreen_deleteRegimen_question.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le traitement ?'**
  String get settingsScreen_deleteRegimen_question;

  /// No description provided for @settingsScreen_deleteRegimenDescription.
  ///
  /// In fr, this message translates to:
  /// **'Cela supprimera votre configuration de pilule actuelle et tous les journaux associés. Cette action est irréversible.'**
  String get settingsScreen_deleteRegimenDescription;

  /// No description provided for @settingsScreen_allLogsHaveBeenCleared.
  ///
  /// In fr, this message translates to:
  /// **'Tous les journaux ont été effacés.'**
  String get settingsScreen_allLogsHaveBeenCleared;

  /// No description provided for @settingsScreen_clearAllLogs_question.
  ///
  /// In fr, this message translates to:
  /// **'Effacer tous les journaux ?'**
  String get settingsScreen_clearAllLogs_question;

  /// No description provided for @settingsScreen_deleteAllLogsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Cela supprimera définitivement tous vos enregistrements de périodes. Les paramètres de l’application ne seront pas affectés.'**
  String get settingsScreen_deleteAllLogsDescription;

  /// No description provided for @settingsScreen_appearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsScreen_appearance;

  /// No description provided for @settingsScreen_historyViewStyle.
  ///
  /// In fr, this message translates to:
  /// **'Style d’historique'**
  String get settingsScreen_historyViewStyle;

  /// No description provided for @settingsScreen_appTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème de l’application'**
  String get settingsScreen_appTheme;

  /// No description provided for @settingsScreen_themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsScreen_themeLight;

  /// No description provided for @settingsScreen_themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsScreen_themeDark;

  /// No description provided for @settingsScreen_themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsScreen_themeSystem;

  /// No description provided for @settingsScreen_dynamicTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème dynamique'**
  String get settingsScreen_dynamicTheme;

  /// No description provided for @settingsScreen_useWallpaperColors.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser les couleurs du fond d’écran'**
  String get settingsScreen_useWallpaperColors;

  /// No description provided for @settingsScreen_themeColor.
  ///
  /// In fr, this message translates to:
  /// **'Couleur du thème'**
  String get settingsScreen_themeColor;

  /// No description provided for @settingsScreen_pickAColor.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une couleur'**
  String get settingsScreen_pickAColor;

  /// No description provided for @settingsScreen_view.
  ///
  /// In fr, this message translates to:
  /// **'Vue'**
  String get settingsScreen_view;

  /// No description provided for @settingsScreen_birthControl.
  ///
  /// In fr, this message translates to:
  /// **'Contraception'**
  String get settingsScreen_birthControl;

  /// No description provided for @settingsScreen_setUpPillRegimen.
  ///
  /// In fr, this message translates to:
  /// **'Configurer le traitement'**
  String get settingsScreen_setUpPillRegimen;

  /// No description provided for @settingsScreen_trackYourDailyPillIntake.
  ///
  /// In fr, this message translates to:
  /// **'Suivre la prise quotidienne de la pilule'**
  String get settingsScreen_trackYourDailyPillIntake;

  /// No description provided for @settingsScreen_dailyPillReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien de pilule'**
  String get settingsScreen_dailyPillReminder;

  /// No description provided for @settingsScreen_reminderTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure du rappel'**
  String get settingsScreen_reminderTime;

  /// No description provided for @settingsScreen_periodPredictionAndReminders.
  ///
  /// In fr, this message translates to:
  /// **'Prédictions et rappels de règles'**
  String get settingsScreen_periodPredictionAndReminders;

  /// No description provided for @settingsScreen_upcomingPeriodReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel de règles à venir'**
  String get settingsScreen_upcomingPeriodReminder;

  /// No description provided for @settingsScreen_remindMeBefore.
  ///
  /// In fr, this message translates to:
  /// **'Me rappeler avant'**
  String get settingsScreen_remindMeBefore;

  /// No description provided for @settingsScreen_notificationTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure de notification'**
  String get settingsScreen_notificationTime;

  /// No description provided for @settingsScreen_overduePeriodReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel de règles en retard'**
  String get settingsScreen_overduePeriodReminder;

  /// No description provided for @settingsScreen_remindMeAfter.
  ///
  /// In fr, this message translates to:
  /// **'Me rappeler après'**
  String get settingsScreen_remindMeAfter;

  /// No description provided for @settingsScreen_dataManagement.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des données'**
  String get settingsScreen_dataManagement;

  /// No description provided for @settingsScreen_clearAllLogs.
  ///
  /// In fr, this message translates to:
  /// **'Effacer tous les journaux'**
  String get settingsScreen_clearAllLogs;

  /// No description provided for @settingsScreen_clearAllPillData.
  ///
  /// In fr, this message translates to:
  /// **'Effacer toutes les données de pilule'**
  String get settingsScreen_clearAllPillData;

  /// No description provided for @settingsScreen_clearAllPillData_question.
  ///
  /// In fr, this message translates to:
  /// **'Effacer toutes les données de pilule ?'**
  String get settingsScreen_clearAllPillData_question;

  /// No description provided for @settingsScreen_deleteAllPillDataDescription.
  ///
  /// In fr, this message translates to:
  /// **'Cela supprimera définitivement votre traitement, vos rappels et votre historique. Cette action est irréversible.'**
  String get settingsScreen_deleteAllPillDataDescription;

  /// No description provided for @settingsScreen_allPillDataCleared.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les données de pilule ont été effacées.'**
  String get settingsScreen_allPillDataCleared;

  /// No description provided for @settingsScreen_dangerZone.
  ///
  /// In fr, this message translates to:
  /// **'Zone à risque'**
  String get settingsScreen_dangerZone;

  /// No description provided for @settingsScreen_clearAllLogsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprime tout votre historique de règles et de symptômes.'**
  String get settingsScreen_clearAllLogsSubtitle;

  /// No description provided for @settingsScreen_clearAllPillDataSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprime votre traitement et l’historique des prises.'**
  String get settingsScreen_clearAllPillDataSubtitle;

  /// No description provided for @settingsScreen_security.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get settingsScreen_security;

  /// No description provided for @securityScreen_enableBiometricLock.
  ///
  /// In fr, this message translates to:
  /// **'Activer le verrouillage biométrique'**
  String get securityScreen_enableBiometricLock;

  /// No description provided for @securityScreen_enableBiometricLockSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Exiger une empreinte digitale ou la reconnaissance faciale pour ouvrir l’application.'**
  String get securityScreen_enableBiometricLockSubtitle;

  /// No description provided for @securityScreen_noBiometricsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucun code, empreinte ou reconnaissance faciale détecté. Veuillez en configurer un dans les paramètres de votre appareil.'**
  String get securityScreen_noBiometricsAvailable;

  /// No description provided for @settingsScreen_preferences.
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get settingsScreen_preferences;

  /// No description provided for @preferencesScreen_tamponReminderButton.
  ///
  /// In fr, this message translates to:
  /// **'Afficher toujours le bouton de rappel'**
  String get preferencesScreen_tamponReminderButton;

  /// No description provided for @preferencesScreen_tamponReminderButtonSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Affiche en permanence le bouton de rappel tampon sur l’écran principal.'**
  String get preferencesScreen_tamponReminderButtonSubtitle;

  /// No description provided for @settingsScreen_about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsScreen_about;

  /// No description provided for @aboutScreen_version.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get aboutScreen_version;

  /// No description provided for @aboutScreen_github.
  ///
  /// In fr, this message translates to:
  /// **'GitHub'**
  String get aboutScreen_github;

  /// No description provided for @aboutScreen_githubSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Code source et suivi des problèmes'**
  String get aboutScreen_githubSubtitle;

  /// No description provided for @aboutScreen_share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get aboutScreen_share;

  /// No description provided for @aboutScreen_shareSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Partager l’application avec des amis'**
  String get aboutScreen_shareSubtitle;

  /// No description provided for @aboutScreen_urlError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’ouvrir le lien.'**
  String get aboutScreen_urlError;

  /// No description provided for @tamponReminderDialog_tamponReminderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappel tampon'**
  String get tamponReminderDialog_tamponReminderTitle;

  /// No description provided for @tamponReminderDialog_tamponReminderMaxDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée maximale : 8 heures.'**
  String get tamponReminderDialog_tamponReminderMaxDuration;

  /// No description provided for @reminderCountdownDialog_title.
  ///
  /// In fr, this message translates to:
  /// **'Rappel dans'**
  String get reminderCountdownDialog_title;

  /// Indicates the time a reminder is due. The {time} placeholder will be a formatted time string (e.g., '2:30 PM').
  ///
  /// In fr, this message translates to:
  /// **'Prévu à {time}'**
  String reminderCountdownDialog_dueAt(Object time);

  /// No description provided for @cycleLengthVarianceWidget_LogAtLeastTwoPeriods.
  ///
  /// In fr, this message translates to:
  /// **'Au moins deux cycles sont nécessaires pour afficher la variance.'**
  String get cycleLengthVarianceWidget_LogAtLeastTwoPeriods;

  /// No description provided for @cycleLengthVarianceWidget_cycleAndPeriodVeriance.
  ///
  /// In fr, this message translates to:
  /// **'Variance du cycle et de la période'**
  String get cycleLengthVarianceWidget_cycleAndPeriodVeriance;

  /// No description provided for @cycleLengthVarianceWidget_averageCycle.
  ///
  /// In fr, this message translates to:
  /// **'Cycle moyen'**
  String get cycleLengthVarianceWidget_averageCycle;

  /// No description provided for @cycleLengthVarianceWidget_averagePeriod.
  ///
  /// In fr, this message translates to:
  /// **'Période moyenne'**
  String get cycleLengthVarianceWidget_averagePeriod;

  /// No description provided for @cycleLengthVarianceWidget_period.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get cycleLengthVarianceWidget_period;

  /// No description provided for @cycleLengthVarianceWidget_cycle.
  ///
  /// In fr, this message translates to:
  /// **'Cycle'**
  String get cycleLengthVarianceWidget_cycle;

  /// No description provided for @flowIntensityWidget_flowIntensityBreakdown.
  ///
  /// In fr, this message translates to:
  /// **'Répartition de l’intensité du flux'**
  String get flowIntensityWidget_flowIntensityBreakdown;

  /// No description provided for @flowIntensityWidget_noFlowDataLoggedYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée de flux enregistrée pour le moment.'**
  String get flowIntensityWidget_noFlowDataLoggedYet;

  /// No description provided for @painLevelWidget_noPainDataLoggedYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée de douleur enregistrée pour le moment.'**
  String get painLevelWidget_noPainDataLoggedYet;

  /// No description provided for @painLevelWidget_painLevelBreakdown.
  ///
  /// In fr, this message translates to:
  /// **'Répartition des émotions'**
  String get painLevelWidget_painLevelBreakdown;

  /// No description provided for @monthlyFlowChartWidget_noDataToDisplay.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée à afficher.'**
  String get monthlyFlowChartWidget_noDataToDisplay;

  /// No description provided for @monthlyFlowChartWidget_cycleFlowPatterns.
  ///
  /// In fr, this message translates to:
  /// **'Schémas de flux menstruel'**
  String get monthlyFlowChartWidget_cycleFlowPatterns;

  /// No description provided for @monthlyFlowChartWidget_cycleFlowPatternsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Chaque ligne représente un cycle complet'**
  String get monthlyFlowChartWidget_cycleFlowPatternsDescription;

  /// No description provided for @symptomFrequencyWidget_noSymptomsLoggedYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucun symptôme enregistré pour le moment.'**
  String get symptomFrequencyWidget_noSymptomsLoggedYet;

  /// No description provided for @symptomFrequencyWidget_mostCommonSymptoms.
  ///
  /// In fr, this message translates to:
  /// **'Douleurs les plus fréquentes'**
  String get symptomFrequencyWidget_mostCommonSymptoms;

  /// No description provided for @yearHeatMapWidget_yearlyOverview.
  ///
  /// In fr, this message translates to:
  /// **'Vue d’ensemble annuelle'**
  String get yearHeatMapWidget_yearlyOverview;

  /// No description provided for @journalViewWidget_logYourFirstPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez votre première période.'**
  String get journalViewWidget_logYourFirstPeriod;

  /// No description provided for @listViewWidget_noPeriodsLogged.
  ///
  /// In fr, this message translates to:
  /// **'Aucune période enregistrée.\nAppuyez sur le bouton + pour en ajouter une.'**
  String get listViewWidget_noPeriodsLogged;

  /// No description provided for @listViewWidget_confirmDelete.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la suppression'**
  String get listViewWidget_confirmDelete;

  /// No description provided for @listViewWidget_confirmDeleteDescription.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer cette entrée ?'**
  String get listViewWidget_confirmDeleteDescription;

  /// No description provided for @emptyPillStateWidget_noPillRegimenFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun traitement trouvé.'**
  String get emptyPillStateWidget_noPillRegimenFound;

  /// No description provided for @emptyPillStateWidget_noPillRegimenFoundDescription.
  ///
  /// In fr, this message translates to:
  /// **'Configurez votre traitement dans les paramètres pour commencer le suivi.'**
  String get emptyPillStateWidget_noPillRegimenFoundDescription;

  /// No description provided for @pillPackVisualiser_yourPack.
  ///
  /// In fr, this message translates to:
  /// **'Votre plaquette'**
  String get pillPackVisualiser_yourPack;

  /// A label showing the total number of pills.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{sur 1 pilule} other{sur {count} pilules}}'**
  String pillStatus_pillsOfTotal(int count);

  /// No description provided for @pillStatus_undo.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get pillStatus_undo;

  /// No description provided for @pillStatus_skip.
  ///
  /// In fr, this message translates to:
  /// **'Ignorer'**
  String get pillStatus_skip;

  /// No description provided for @pillStatus_markAsTaken.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme prise'**
  String get pillStatus_markAsTaken;

  /// No description provided for @regimenSetupWidget_setUpPillRegimen.
  ///
  /// In fr, this message translates to:
  /// **'Configurer le traitement'**
  String get regimenSetupWidget_setUpPillRegimen;

  /// No description provided for @regimenSetupWidget_packName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la plaquette'**
  String get regimenSetupWidget_packName;

  /// No description provided for @regimenSetupWidget_pleaseEnterAName.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir un nom'**
  String get regimenSetupWidget_pleaseEnterAName;

  /// No description provided for @regimenSetupWidget_activePills.
  ///
  /// In fr, this message translates to:
  /// **'Pilules actives'**
  String get regimenSetupWidget_activePills;

  /// No description provided for @regimenSetupWidget_enterANumber.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez un nombre'**
  String get regimenSetupWidget_enterANumber;

  /// No description provided for @regimenSetupWidget_placeboPills.
  ///
  /// In fr, this message translates to:
  /// **'Pilules placebo'**
  String get regimenSetupWidget_placeboPills;

  /// No description provided for @regimenSetupWidget_firstDayOfThisPack.
  ///
  /// In fr, this message translates to:
  /// **'Premier jour de cette plaquette'**
  String get regimenSetupWidget_firstDayOfThisPack;

  /// No description provided for @symptomEntrySheet_logYourDay.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez votre journée'**
  String get symptomEntrySheet_logYourDay;

  /// No description provided for @symptomEntrySheet_symptomsOptional.
  ///
  /// In fr, this message translates to:
  /// **'Symptômes (optionnel)'**
  String get symptomEntrySheet_symptomsOptional;

  /// No description provided for @periodDetailsSheet_symptoms.
  ///
  /// In fr, this message translates to:
  /// **'Symptômes'**
  String get periodDetailsSheet_symptoms;

  /// No description provided for @periodDetailsSheet_flow.
  ///
  /// In fr, this message translates to:
  /// **'Flux'**
  String get periodDetailsSheet_flow;

  /// A label showing the total number of days until period is due.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{jour} other{jours}}'**
  String periodPredictionCircle_days(int count);

  /// No description provided for @temperature.
  ///
  /// In fr, this message translates to:
  /// **'Température (°C)'**
  String get temperature;

  /// No description provided for @noDataAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée disponible'**
  String get noDataAvailable;

  /// No description provided for @temperatureChart_description.
  ///
  /// In fr, this message translates to:
  /// **'Évolution température/cycle'**
  String get temperatureChart_description;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
