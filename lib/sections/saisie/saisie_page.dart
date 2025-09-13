// ignore_for_file: use_build_context_synchronously

import 'package:cycles/models/daily_entry.dart';
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

  final int _selectedIndex = 2;

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final StorageService _storage = StorageService();
  DateTime _selectedDate = DateTime.now();
  bool _loading = true;
  DailyEntry? _todayEntry;
  int _bleeding = 0;
  String _mucus = 'Aucun';
  String _pain = 'Aucun';
  String _mood = 'Neutre';

  final List<String> mucusOptions = ['Aucun', 'Sec', 'Collant', 'Clair'];
  final List<String> painOptions = [
    'Aucun',
    'Douleur légère',
    'Douleur modérée',
    'Douleur forte',
  ];
  final List<String> moodOptions = ['Triste', 'Neutre', 'Heureuse', 'Irritée'];

  @override
  void initState() {
    super.initState();
    _loadForDate(_selectedDate);
  }

  Future<void> _loadForDate(DateTime date) async {
    setState(() => _loading = true);
    final entry = await _storage.loadEntryForDate(date);
    if (entry != null) {
      _tempController.text = entry.temperature.toStringAsFixed(2);
      _bleeding = entry.bleedingLevel;
      _mucus = entry.mucus;
      _pain = entry.pain;
      _mood = entry.mood;
      _notesController.text = entry.notes;
    } else {
      _tempController.text = '';
      _bleeding = 0;
      _mucus = 'Aucun';
      _pain = 'Aucun';
      _mood = 'Neutre';
      _notesController.text = '';
    }
    setState(() {
      _todayEntry = entry;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (_tempController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez renseigner la température')),
      );
      return;
    }
    final temp = double.tryParse(_tempController.text.replaceAll(',', '.'));
    if (temp == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Format de température invalide')));
      return;
    }

    final entry = DailyEntry(
      date: _selectedDate,
      temperature: temp,
      bleedingLevel: _bleeding,
      mucus: _mucus,
      pain: _pain,
      mood: _mood,
      notes: _notesController.text,
    );

    await _storage.saveEntry(entry);
    setState(() => _todayEntry = entry);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Saisie enregistrée')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {},
        ),
        title: Text(
          'Saisie journalière',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WeekPicker(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    onLoadForDate: (date) async {},
                  ),

                  SizedBox(height: 12),
                  temperatureCard(
                    controller: _tempController,
                    context: context,
                  ),
                  SizedBox(height: 12),
                  saignementCard(
                    bleeding: _bleeding,
                    onChanged: (v) => setState(() => _bleeding = v),
                    context: context,
                  ),
                  SizedBox(height: 12),
                  iconOptionsCard(
                    title: "Glaires",
                    labels: ["Sèches", "Visqueuses", "Crémeuses", "Élastiques"],
                    icons: [
                      "assets/images/dry.png",
                      "assets/images/creamy.png",
                      "assets/images/clear.png",
                      "assets/images/stretchy.png",
                    ],
                    context: context,
                    selected: [], // une seule valeur
                    onChanged: (val) => print("Glaire sélectionnée: $val"),
                    singleSelection: true,
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    inactiveColor: Theme.of(
                      context,
                    ).colorScheme.tertiaryContainer,
                    onColor: Theme.of(context).colorScheme.onTertiary,
                  ),
                  SizedBox(height: 12),
                  iconOptionsCard(
                    title: "Douleurs",
                    labels: ["Tête", "Dos", "Ventre", "Poitrine", "Ovaires"],
                    icons: [
                      "assets/images/head.png",
                      "assets/images/back.png",
                      "assets/images/stomach.png",
                      "assets/images/chest.png",
                      "assets/images/uterus.png",
                    ],
                    context: context,
                    selected: [],
                    onChanged: (val) => print("Douleurs sélectionnées: $val"),
                    singleSelection: false,

                    inactiveColor: Theme.of(context).colorScheme.secondary,
                    activeColor: Theme.of(
                      context,
                    ).colorScheme.secondaryContainer,
                    onColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                  SizedBox(height: 12),
                  iconOptionsCard(
                    title: "Humeurs",
                    labels: ["Triste", "Neutre", "Heureuse", "Irritée"],
                    icons: [
                      "assets/icons/sad.svg",
                      "assets/icons/neutre.svg",
                      "assets/icons/happy.svg",
                      "assets/icons/irritated.svg",
                    ],
                    context: context,
                    selected: [],
                    onChanged: (val) => print("Douleurs sélectionnées: $val"),
                    singleSelection: false,
                    inactiveColor: Theme.of(context).colorScheme.primary,
                    activeColor: Theme.of(context).colorScheme.primaryContainer,
                    onColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  SizedBox(height: 18),
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
