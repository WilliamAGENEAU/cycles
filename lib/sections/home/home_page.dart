import 'package:cycles/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget.dart';

class HomePage extends StatefulWidget {
  static const String homePageRoute = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MenstrualCyclePhaseView(
          size: 300,
          viewType: MenstrualCycleViewType.circleText,
          phaseTextBoundaries: PhaseTextBoundaries.outside,
          isRemoveBackgroundPhaseColor: true,
          isAutoSetData: true,
          theme: MenstrualCycleTheme.circle,
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
