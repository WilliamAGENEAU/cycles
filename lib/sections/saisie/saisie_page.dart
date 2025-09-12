import 'package:cycles/values/values.dart';
import 'package:cycles/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

class SaisiePage extends StatefulWidget {
  static const String saisiePageRoute = StringConst.SAISIE_PAGE;

  const SaisiePage({super.key});

  @override
  State<SaisiePage> createState() => _SaisiePageState();
}

class _SaisiePageState extends State<SaisiePage> {
  static const List<String> _routes = [
    StringConst.HOME_PAGE,
    StringConst.ANALYSE_PAGE,
    StringConst.SAISIE_PAGE,
    StringConst.CALENDRIER_PAGE,
    StringConst.HISTORIQUE_PAGE,
  ];

  final int _selectedIndex = 2;

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Saisie Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
