// ignore_for_file: deprecated_member_use

import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/flows/flow_enum.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/models/period_prediction_result.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class PeriodJournalView extends StatefulWidget {
  final List<PeriodDay> periodLogEntries;
  final bool isLoading;
  final Function(PeriodDay) onLogTapped;
  final PeriodPredictionResult? predictionResult;
  final Function(DateTime) onLogRequested;

  const PeriodJournalView({
    super.key,
    required this.periodLogEntries,
    required this.isLoading,
    required this.onLogTapped,
    this.predictionResult,
    required this.onLogRequested,
  });

  @override
  State<PeriodJournalView> createState() => _PeriodJournalViewState();
}

class _PeriodJournalViewState extends State<PeriodJournalView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  Map<DateTime, PeriodDay> _logMap = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _processEntries();
  }

  @override
  void didUpdateWidget(covariant PeriodJournalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.periodLogEntries != oldWidget.periodLogEntries) {
      _processEntries();
    }
  }

  void _processEntries() {
    _logMap = {
      for (var log in widget.periodLogEntries)
        DateUtils.dateOnly(log.date): log,
    };
  }

  bool _isPeriodDay(DateTime day) {
    final log = _logMap[DateUtils.dateOnly(day)];
    return log != null && log.flow != FlowRate.none;
  }

  bool _isPredictedDay(DateTime day) {
    final startDate = widget.predictionResult?.estimatedStartDate;
    final endDate = widget.predictionResult?.estimatedEndDate;
    if (startDate == null || endDate == null) return false;

    final d = DateUtils.dateOnly(day);
    return !d.isBefore(DateUtils.dateOnly(startDate)) &&
        !d.isAfter(DateUtils.dateOnly(endDate));
  }

  bool _isLoggedSymptomDay(DateTime day) {
    final log = _logMap[DateUtils.dateOnly(day)];
    return log != null &&
        log.flow == FlowRate.none &&
        (log.symptoms?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (widget.periodLogEntries.isEmpty) {
      return Expanded(
        child: Center(child: Text(l10n.journalViewWidget_logYourFirstPeriod)),
      );
    }

    final earliestLogDate = widget.periodLogEntries
        .reduce((a, b) => a.date.isBefore(b.date) ? a : b)
        .date;

    // 🔹 On autorise l'affichage jusqu’à la fin de la période prédite
    final predictedEnd = widget.predictionResult?.estimatedEndDate;
    final lastVisibleDate =
        predictedEnd != null && predictedEnd.isAfter(DateTime.now())
        ? predictedEnd.add(const Duration(days: 5))
        : DateTime.now().add(const Duration(days: 5));

    return Expanded(
      child: TableCalendar(
        locale: 'fr_FR',
        startingDayOfWeek: StartingDayOfWeek.monday,
        firstDay: earliestLogDate.subtract(const Duration(days: 365)),
        lastDay: lastVisibleDate, // ✅ futur visible
        focusedDay: _focusedDay,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextFormatter: (date, locale) {
            final formatted = DateFormat.yMMMM(locale).format(date);
            return formatted[0].toUpperCase() + formatted.substring(1);
          },
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white70),
          weekendStyle: TextStyle(color: Colors.white70),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          todayTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          defaultTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.white),
        ),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          // ⛔ Bloque uniquement la saisie dans le futur
          if (selectedDay.isAfter(DateTime.now())) return;
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          final log = _logMap[DateUtils.dateOnly(selectedDay)];
          if (log != null) {
            widget.onLogTapped(log);
          } else {
            widget.onLogRequested(selectedDay);
          }
        },
        onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final isPeriod = _isPeriodDay(day);
            final isPredicted = _isPredictedDay(day);
            final isLoggedSymptom = _isLoggedSymptomDay(day);
            final today = DateUtils.isSameDay(day, DateTime.now());

            // --- JOUR DE RÈGLE ---
            if (isPeriod) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            // --- JOUR PRÉDIT ---
            if (isPredicted) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            // --- JOUR AVEC SYMPTÔME (petit point) ---
            if (isLoggedSymptom) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              );
            }

            // --- JOUR NORMAL OU AUJOURD’HUI ---
            return Container(
              alignment: Alignment.center,
              decoration: today
                  ? BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    )
                  : null,
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: today ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
