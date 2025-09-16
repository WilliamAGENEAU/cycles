import 'package:flutter/material.dart';
import 'package:cycles/sections/home/home_page.dart';
import 'package:cycles/sections/analyse/analyse_page.dart';
import 'package:cycles/sections/saisie/saisie_page.dart';
import 'package:cycles/sections/calendrier/calendrier_page.dart';
import 'package:cycles/sections/historique/historique_page.dart';

class RouteConfiguration {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/analyse':
        return MaterialPageRoute(builder: (_) => const AnalysePage());
      case '/saisie':
        return MaterialPageRoute(builder: (_) => const SaisiePage());
      case '/calendrier':
        return MaterialPageRoute(builder: (_) => const CalendrierPage());
      case '/historique':
        return MaterialPageRoute(builder: (_) => const HistoriquePage());
      default:
        // Fallback vers HomePage si la route n'est pas reconnue
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
