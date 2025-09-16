import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'routes/routes.dart';
import 'sections/home/home_page.dart';
import 'theme.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  MenstrualCycleWidget.init(
    secretKey: "11a1215l0119a140409p0919",
    ivKey: "23a1dfr5lyhd9a1404845001",
  );
  runApp(const CyclesApp());
}

class CyclesApp extends StatelessWidget {
  const CyclesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final theme = MaterialTheme(Theme.of(context).textTheme);
    return MaterialApp(
      title: 'Cycles',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.homePageRoute,
      onGenerateRoute: RouteConfiguration.onGenerateRoute,
    );
  }
}
