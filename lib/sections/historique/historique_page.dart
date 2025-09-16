import 'package:cycles/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:menstrual_cycle_widget/ui/graphs_view/menstrual_cycle_history_graph.dart';

class HistoriquePage extends StatefulWidget {
  static const String historiquePageRoute = '/historique';
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  final int _selectedIndex = 4;
  static const List<String> _routes = [
    '/home',
    '/analyse',
    '/saisie',
    '/calendrier',
    '/historique',
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

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: MenstrualCycleHistoryGraph(),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
