import 'package:cycles/routes/routes.dart';
import 'package:cycles/sections/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'util.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');

  runApp(const CyclesApp());
}

class CyclesApp extends StatelessWidget {
  const CyclesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Cycles',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.homePageRoute,
      onGenerateRoute: RouteConfiguration.onGenerateRoute,
    );
  }
}
