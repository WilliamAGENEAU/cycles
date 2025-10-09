import 'package:cycles/database/repositories/periods_repository.dart';
import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/models/periods/period.dart';
import 'package:cycles/widgets/insights/cycle_length_variance.dart';
import 'package:cycles/widgets/insights/douleurs_frequency.dart';
import 'package:cycles/widgets/insights/emotion_intensity.dart';
import 'package:cycles/widgets/insights/temperature_chart.dart';
import 'package:flutter/material.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late Future<List<dynamic>> _insightsDataFuture;
  final periodsRepo = PeriodsRepository();

  @override
  void initState() {
    super.initState();
    _loadInsightsData();
  }

  void _loadInsightsData() {
    _insightsDataFuture = Future.wait([
      periodsRepo.readAllPeriods(),
      periodsRepo.readAllPeriodLogs(),
      periodsRepo.getMonthlyPeriodFlows(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<List<dynamic>>(
      future: _insightsDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('${l10n.insightsScreen_errorPrefix} ${snapshot.error}'),
          );
        }

        if (snapshot.hasData) {
          final allPeriods = snapshot.data![0] as List<Period>;
          final allLogs = snapshot.data![1] as List<PeriodDay>;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TemperatureCycleChart(logs: allLogs, periods: allPeriods),

              DouleursFrequencyWidget(logs: allLogs, periods: allPeriods),

              CycleLengthVarianceWidget(periods: allPeriods),

              EmotionBreakdownWidget(logs: allLogs),
            ],
          );
        }
        return Center(child: Text(l10n.insightsScreen_noDataAvailable));
      },
    );
  }
}
