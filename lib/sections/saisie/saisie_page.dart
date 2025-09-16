import 'package:cycles/services/storage_services.dart';
import 'package:cycles/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:menstrual_cycle_widget/ui/menstrual_calender_view.dart';
import 'package:menstrual_cycle_widget/ui/menstrual_log_period_view.dart';
import 'package:menstrual_cycle_widget/ui/model/display_symptoms_data.dart';

class SaisiePage extends StatefulWidget {
  static const String saisiePageRoute = '/saisie';

  const SaisiePage({super.key});

  @override
  State<SaisiePage> createState() => _SaisiePageState();
}

class _SaisiePageState extends State<SaisiePage> {
  static const List<String> _routes = [
    '/home',
    '/analyse',
    '/saisie',
    '/calendrier',
    '/historique',
  ];
  final StorageService _storage = StorageService();

  DateTime _selectedDate = DateTime.now();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  int _bleeding = -1;
  List<String> _mucusSelected = [];
  List<String> _painSelected = [];
  List<String> _moodSelected = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadForDate(_selectedDate);

    // Sauvegarde auto pour la température et les notes
    _tempController.addListener(_saveEntry);
    _notesController.addListener(_saveEntry);
  }

  Future<void> _loadForDate(DateTime date) async {
    setState(() => _loading = true);
    final entry = await _storage.loadEntryForDate(date);
    if (entry != null) {
      _tempController.text = entry.temperature?.toStringAsFixed(2) ?? '';
      _bleeding = entry.bleeding;
      _mucusSelected = List<String>.from(entry.mucus);
      _painSelected = List<String>.from(entry.pain);
      _moodSelected = List<String>.from(entry.mood);
      _notesController.text = entry.notes;
    } else {
      _tempController.text = '';
      _bleeding = -1;
      _mucusSelected = [];
      _painSelected = [];
      _moodSelected = [];
      _notesController.text = '';
    }
    setState(() => _loading = false);
  }

  Future<void> _saveEntry() async {
    final tempText = _tempController.text.trim();
    double? temp;
    if (tempText.isNotEmpty) {
      temp = double.tryParse(tempText.replaceAll(',', '.'));
    }

    final entry = DailyEntry(
      date: _selectedDate,
      temperature: temp,
      bleeding: _bleeding,
      mucus: _mucusSelected,
      pain: _painSelected,
      mood: _moodSelected,
      notes: _notesController.text,
    );

    await _storage.saveEntry(entry);
  }

  final int _selectedIndex = 2;

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  void dispose() {
    _tempController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Correction : fonctions pour les callbacks
  void _onError(String error) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Erreur: $error')));
  }

  void _onSuccess(int id) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Saisie enregistrée (id: $id)')));
    // Tu peux recharger les données ou rafraîchir les graphs ici si besoin
  }

  int _next(int min, int max) {
    // Retourne un nombre aléatoire entre min et max
    return min + (max - min) ~/ 2;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saisie journalière'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 350, // Hauteur adaptée pour le calendrier
                    child: MenstrualCycleCalenderView(
                      themeColor: theme.colorScheme.primary,
                      daySelectedColor: theme.colorScheme.secondary,
                      logPeriodText: "Log Period",
                      backgroundColorCode:
                          theme.colorScheme.surfaceContainerHigh,
                      hideInfoView: false,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                        _loadForDate(date);
                      },
                      onDataChanged: (value) {},
                      hideBottomBar: false,
                      hideLogPeriodButton: false,
                      isExpanded: false,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 550, // Ajoute une hauteur fixe pour le log period
                    child: MenstrualLogPeriodView(
                      displaySymptomsData: DisplaySymptomsData(),
                      onError: _onError,
                      onSuccess: _onSuccess,
                      symptomsLogDate: DateTime.now().add(
                        Duration(days: _next(1, 5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
