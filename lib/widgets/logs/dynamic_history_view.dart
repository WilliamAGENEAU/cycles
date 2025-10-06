import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/models/period_prediction_result.dart';
import 'package:cycles/models/periods/period.dart';
import 'package:cycles/services/settings_service.dart';
import 'package:cycles/widgets/logs/journal_view.dart';
import 'package:cycles/widgets/logs/list_view.dart';
import 'package:flutter/material.dart';

class DynamicHistoryView extends StatelessWidget {
  final PeriodPredictionResult? predictionResult;
  final PeriodHistoryView selectedView;
  final List<PeriodDay> periodLogEntries;
  final List<Period> periodEntries;
  final bool isLoading;
  final Function(DateTime) onLogRequested;
  final Function(PeriodDay) onLogTapped;

  const DynamicHistoryView({
    super.key,
    required this.predictionResult,
    required this.selectedView,
    required this.periodLogEntries,
    required this.periodEntries,
    required this.isLoading,
    required this.onLogRequested,
    required this.onLogTapped,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedView) {
      case PeriodHistoryView.list:
        return PeriodListView(
          periodLogEntries: periodLogEntries,
          periodEntries: periodEntries,
          isLoading: isLoading,
          onLogTapped: onLogTapped,
        );
      case PeriodHistoryView.journal:
        return PeriodJournalView(
          periodLogEntries: periodLogEntries,
          predictionResult: predictionResult,
          isLoading: isLoading,
          onLogTapped: onLogTapped,
          onLogRequested: onLogRequested,
        );
    }
  }
}
