// lib/screens/logs_screen.dart
import 'package:cycles/database/repositories/periods_repository.dart';
import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/models/period_prediction_result.dart';
import 'package:cycles/models/periods/period.dart';
import 'package:cycles/screens/main_screen.dart';
import 'package:cycles/services/notification_service.dart';
import 'package:cycles/services/period_logger_service.dart';
import 'package:cycles/services/settings_service.dart';
import 'package:cycles/utils/period_predictor.dart';
import 'package:cycles/widgets/basic_progress_circle.dart';
import 'package:cycles/widgets/dialogs/reminder_countdown_dialog.dart';
import 'package:cycles/widgets/dialogs/tampon_reminder_dialog.dart';
import 'package:cycles/widgets/logs/dynamic_history_view.dart';
import 'package:cycles/widgets/sheets/period_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogsScreen extends StatefulWidget {
  final Function(FabState) onFabStateChange;

  const LogsScreen({super.key, required this.onFabStateChange});

  @override
  State<LogsScreen> createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  final periodsRepo = PeriodsRepository();
  final SettingsService _settingsService = SettingsService();

  List<PeriodDay> _periodLogEntries = [];
  List<Period> _periodEntries = [];
  bool _isLoading = true;
  PeriodPredictionResult? _predictionResult;
  PeriodHistoryView _selectedView = PeriodHistoryView.journal;

  // UI values
  int _dayInCycle = 1;
  double _periodFraction = 0.0;
  double _ovulationStartFraction = 0.0;
  int _cycleLength = 28;

  @override
  void initState() {
    super.initState();
    _refreshPeriodLogs();
  }

  Future<void> handleTamponReminderCountdown() async {
    final dueDate = await NotificationService.getTamponReminderScheduledTime();
    if (dueDate == null) return;
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ReminderCountdownDialog(
          dueDate: dueDate,
          onDelete: handleCancelReminder,
        ),
      );
    }
  }

  Future<void> handleTamponReminder(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final reminderDateTime = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) => const TimeSelectionDialog(),
    );

    if (reminderDateTime == null) return;

    await NotificationService.scheduleTamponReminder(
      reminderDateTime: reminderDateTime,
      title: l10n.notification_tamponReminderTitle,
      body: l10n.notification_tamponReminderBody,
    );

    await NotificationService.setTamponReminderScheduledTime(reminderDateTime);

    if (context.mounted) {
      final formattedTime = TimeOfDay.fromDateTime(
        reminderDateTime,
      ).format(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.logScreen_tamponReminderSetFor} $formattedTime',
            ),
          ),
        );

      _refreshPeriodLogs();
    }
  }

  Future<void> handleCancelReminder() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await NotificationService.cancelTamponReminder();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.logScreen_tamponReminderCancelled)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.logScreen_couldNotCancelReminder}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _refreshPeriodLogs();
    }
  }

  Future<void> createNewLog(DateTime selectedDate) async {
    final bool wasLogSuccessful = await PeriodLoggerService.showAndLogPeriod(
      context,
      selectedDate,
    );

    if (wasLogSuccessful && mounted) {
      _refreshPeriodLogs();
    }
  }

  Future<void> _updateExistingLog(PeriodDay updatedLog) async {
    await periodsRepo.updatePeriodLog(updatedLog);
    if (mounted) Navigator.of(context).pop();
    _refreshPeriodLogs();
  }

  Future<void> _deleteExistingLog(int? id) async {
    if (id == null) return;
    await periodsRepo.deletePeriodLog(id);
    _refreshPeriodLogs();
  }

  Future<void> _refreshPeriodLogs() async {
    setState(() => _isLoading = true);

    final periodDays = await periodsRepo.readAllPeriodLogs();
    final periods = await periodsRepo.readAllPeriods();
    final predictionResult = PeriodPredictor.estimateNextPeriod(
      periods,
      DateTime.now(),
    );
    final selectedView = await _settingsService.getHistoryView();

    int dayInCycle = 1;
    int cycleLength = predictionResult?.averageCycleLength ?? 28;
    int periodDaysCount = predictionResult?.averagePeriodDuration ?? 5;
    double periodFraction = (periodDaysCount / cycleLength);
    double ovulationStartFraction = 0.0;

    if (periods.isNotEmpty) {
      final sorted = [...periods]
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
      final currentPeriod = sorted.first;
      final now = DateTime.now();

      // Calcule le jour actuel dans le cycle
      final diff = now.difference(currentPeriod.startDate).inDays + 1;
      dayInCycle = diff.clamp(1, cycleLength);

      // Calcule la fraction des règles
      if (currentPeriod.totalDays > 0) {
        periodDaysCount = currentPeriod.totalDays;
      }
      periodFraction = periodDaysCount / cycleLength;

      // Calcule la fenêtre d’ovulation (jour 14 en moyenne)
      int ovulationDay = (cycleLength / 2).round();
      ovulationStartFraction =
          (ovulationDay - 4) / cycleLength; // 4 jours avant ovulation
    }

    setState(() {
      _periodLogEntries = periodDays;
      _periodEntries = periods;
      _predictionResult = predictionResult;
      _selectedView = selectedView;
      _dayInCycle = dayInCycle;
      _cycleLength = cycleLength;
      _periodFraction = periodFraction;
      _ovulationStartFraction = ovulationStartFraction;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String predictionText = '';
    if (_isLoading) {
      predictionText = l10n.logsScreen_calculatingPrediction;
    } else if (_predictionResult == null) {
      predictionText = l10n.logScreen_logAtLeastTwoPeriods;
    } else {
      final datePart = DateFormat(
        'dd/MM/yyyy',
      ).format(_predictionResult!.estimatedStartDate);
      if (_predictionResult!.daysUntilDue > 0) {
        predictionText = '${l10n.logScreen_nextPeriodEstimate}: $datePart';
      } else if (_predictionResult!.daysUntilDue == 0) {
        predictionText = '${l10n.logScreen_periodDueToday} $datePart';
      } else {
        predictionText =
            '${l10n.logScreen_periodOverdueBy(-_predictionResult!.daysUntilDue)}: $datePart';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 100),
        Stack(
          alignment: Alignment.center,
          children: [
            BasicProgressCircle(
              periodFraction: _periodFraction,
              ovulationStartFraction: _ovulationStartFraction,
              ovulationFraction: 7 / _cycleLength,
              circleSize: 220,
              strokeWidth: 20,
              dayInCycle: _dayInCycle,
              cycleLength: _cycleLength,
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Jour',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  '$_dayInCycle',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          predictionText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: DynamicHistoryView(
            predictionResult: _predictionResult,
            selectedView: _selectedView,
            periodLogEntries: _periodLogEntries,
            periodEntries: _periodEntries,
            isLoading: _isLoading,
            onLogRequested: createNewLog,
            onLogTapped: (log) => _showDetailsBottomSheet(log),
          ),
        ),
      ],
    );
  }

  void _showDetailsBottomSheet(PeriodDay log) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return PeriodDetailsBottomSheet(
          log: log,
          onDelete: () => _deleteExistingLog(log.id),
          onSave: _updateExistingLog,
        );
      },
    );
  }
}
