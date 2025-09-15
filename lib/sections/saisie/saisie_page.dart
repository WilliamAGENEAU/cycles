import 'package:cycles/services/storage_services.dart';
import 'package:cycles/values/values.dart';
import 'package:cycles/widgets/icon_option_card.dart';
import 'package:cycles/widgets/nav_bar.dart';
import 'package:cycles/widgets/saignement_card.dart';
import 'package:cycles/widgets/temperature_card.dart';
import 'package:cycles/widgets/week_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat.yMMMMd('fr_FR').format(_selectedDate);
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
                  WeekPicker(
                    selectedDate: _selectedDate,
                    onDateSelected: (d) async {
                      _selectedDate = d;
                      await _loadForDate(d);
                    },
                    onLoadForDate: (d) async => await _loadForDate(d),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dateLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  // Temperature
                  temperatureCard(
                    controller: _tempController,
                    context: context,
                  ),
                  const SizedBox(height: 12),

                  // Saignement
                  saignementCard(
                    bleeding: _bleeding,
                    onChanged: (v) {
                      setState(() => _bleeding = v);
                      _saveEntry();
                    },
                    context: context,
                  ),
                  const SizedBox(height: 12),

                  // Glaires
                  iconOptionsCard(
                    title: 'Glaires',
                    labels: AppValues.mucusLabels,
                    icons: AppValues.mucusIcons,
                    context: context,
                    selected: _mucusSelected,
                    onChanged: (val) {
                      setState(() => _mucusSelected = val);
                      _saveEntry();
                    },
                    singleSelection: true,
                    activeColor: theme.colorScheme.tertiary,
                    inactiveColor: theme.colorScheme.tertiaryContainer,
                  ),
                  const SizedBox(height: 12),

                  // Douleurs
                  iconOptionsCard(
                    title: 'Douleurs',
                    labels: AppValues.painLabels,
                    icons: AppValues.painIcons,
                    context: context,
                    selected: _painSelected,
                    onChanged: (val) {
                      setState(() => _painSelected = val);
                      _saveEntry();
                    },
                    singleSelection: false,
                    activeColor: theme.colorScheme.secondary,
                    inactiveColor: theme.colorScheme.secondaryContainer,
                  ),
                  const SizedBox(height: 12),

                  // Humeurs
                  iconOptionsCard(
                    title: 'Humeurs',
                    labels: AppValues.moodLabels,
                    icons: AppValues.moodIcons,
                    context: context,
                    selected: _moodSelected,
                    onChanged: (val) {
                      setState(() => _moodSelected = val);
                      _saveEntry();
                    },
                    singleSelection: false,
                    activeColor: theme.colorScheme.primary,
                    inactiveColor: theme.colorScheme.primaryContainer,
                  ),

                  const SizedBox(height: 18),
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
