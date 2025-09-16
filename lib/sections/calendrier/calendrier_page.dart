import 'package:cycles/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget.dart';

class CalendrierPage extends StatefulWidget {
  static const String calendrierPageRoute = '/calendrier';
  const CalendrierPage({super.key});

  @override
  State<CalendrierPage> createState() => _CalendrierPageState();
}

class _CalendrierPageState extends State<CalendrierPage> {
  final int _selectedIndex = 3;
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
        title: const Text('Calendrier'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: MenstrualCycleMonthlyCalenderView(
                themeColor: Colors.black,
                hideInfoView: false,
                daySelectedColor: Colors.blue,
                onDataChanged: (value) {},
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
