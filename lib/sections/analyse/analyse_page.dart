import 'package:cycles/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:menstrual_cycle_widget/ui/graphs_view/menstrual_body_temperature_graph.dart';
import 'package:menstrual_cycle_widget/ui/graphs_view/menstrual_cycle_periods_graph.dart';
import 'package:menstrual_cycle_widget/ui/graphs_view/menstrual_cycle_trends_graph.dart';
import 'package:menstrual_cycle_widget/utils/enumeration.dart';

class AnalysePage extends StatefulWidget {
  static const String analysePageRoute = '/analyse';
  const AnalysePage({super.key});

  @override
  State<AnalysePage> createState() => _AnalysePageState();
}

class _AnalysePageState extends State<AnalysePage> {
  final int _selectedIndex = 1;
  static const List<String> _routes = [
    '/home',
    '/analyse',
    '/saisie',
    '/calendrier',
    '/historique',
  ];

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  final List<Widget> _graphs = [
    MenstrualBodyTemperatureGraph(
      bodyTemperatureUnits: BodyTemperatureUnits.celsius,
      isShowMoreOptions: true,
      onPdfDownloadCallback: (pdfPath) async {
        // This function will be called when the user downloads an pdf
        // pdfPath contains the path to the downloaded pdf
      },
      onImageDownloadCallback: (imagePath) async {
        // This function will be called when the user downloads an image
        // imagePath contains the path to the downloaded image
      },
    ),
    MenstrualCycleTrendsGraph(
      isShowMoreOptions: true,
      onPdfDownloadCallback: (pdfPath) async {
        // This function will be called when the user downloads an pdf
        // pdfPath contains the path to the downloaded pdf
      },
      onImageDownloadCallback: (imagePath) async {
        // This function will be called when the user downloads an image
        // imagePath contains the path to the downloaded image
      },
    ),
    MenstrualCyclePeriodsGraph(
      isShowMoreOptions: true,
      onPdfDownloadCallback: (pdfPath) async {
        // This function will be called when the user downloads an pdf
        // pdfPath contains the path to the downloaded pdf
      },
      onImageDownloadCallback: (imagePath) async {
        // This function will be called when the user downloads an image
        // imagePath contains the path to the downloaded image
      },
    ),
  ];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    // ...chargement...
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: PageView.builder(
                itemCount: _graphs.length,
                itemBuilder: (context, index) {
                  return Center(child: _graphs[index]);
                },
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
