import 'package:cycles/database/repositories/periods_repository.dart';
import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/flows/flow_data.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/models/periods/period.dart';
import 'package:cycles/widgets/insights/cycle_length_variance.dart';
import 'package:cycles/widgets/insights/flow_intensity.dart';
import 'package:cycles/widgets/insights/monthly_flow.dart';
import 'package:cycles/widgets/insights/pain_intensity.dart';
import 'package:cycles/widgets/insights/symptom_frequency.dart';
import 'package:cycles/widgets/insights/year_heat_map.dart';
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
          final allFlows = snapshot.data![2] as List<MonthlyFlowData>;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SymptomFrequencyWidget(logs: allLogs),

              CycleLengthVarianceWidget(periods: allPeriods),

              PainBreakdownWidget(logs: allLogs),

              FlowBreakdownWidget(logs: allLogs),

              FlowPatternsWidget(monthlyFlowData: allFlows),

              YearHeatmapWidget(logs: allLogs),
            ],
          );
        }
        return Center(child: Text(l10n.insightsScreen_noDataAvailable));
      },
    );
  }
}
