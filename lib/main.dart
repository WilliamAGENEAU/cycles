import 'package:cycles/database/repositories/periods_repository.dart';
import 'package:cycles/l10n/app_localizations.dart';
import 'package:cycles/models/themes/app_theme_mode_enum.dart';
import 'package:cycles/notifiers/theme_notifier.dart';
import 'package:cycles/screens/auth_gate.dart';
import 'package:cycles/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ✅ ajout
import 'package:intl/date_symbol_data_local.dart'; // ✅ ajout

final periodsRepository = PeriodsRepository();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialisation de la localisation française pour les dates
  await initializeDateFormatting('fr_FR', null);
  Intl.defaultLocale = 'fr_FR';

  // ✅ Fuseau horaire
  tz_data.initializeTimeZones();
  try {
    final String localTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone));
  } catch (e) {
    tz.setLocalLocation(tz.getLocation('Etc/UTC'));
  }

  await NotificationService.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        final bool useDynamicTheme = themeNotifier.isDynamicEnabled;

        if (useDynamicTheme && lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          final Color seed = themeNotifier.themeColor;

          lightColorScheme = ColorScheme.fromSeed(seedColor: seed);
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: seed,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // ✅ Configuration complète pour le français
          locale: const Locale('fr', 'FR'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],

          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          themeMode: themeNotifier.themeMode.getThemeMode(),
          home: const AuthGate(),
        );
      },
    );
  }
}
