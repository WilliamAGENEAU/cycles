import 'package:cycles/services/storage_services.dart';
import 'package:cycles/values/values.dart';
import 'package:cycles/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendrierPage extends StatefulWidget {
  static const String calendrierPageRoute = StringConst.CALENDRIER_PAGE;

  const CalendrierPage({super.key});

  @override
  State<CalendrierPage> createState() => _CalendrierPageState();
}

class _CalendrierPageState extends State<CalendrierPage> {
  static const List<String> _routes = [
    StringConst.HOME_PAGE,
    StringConst.ANALYSE_PAGE,
    StringConst.SAISIE_PAGE,
    StringConst.CALENDRIER_PAGE,
    StringConst.HISTORIQUE_PAGE,
  ];

  final StorageService _storage = StorageService();
  Map<DateTime, List> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final int _selectedIndex = 3;

  final ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _selectedDay = DateTime.now();

    // lancer l’animation une fois que le widget est construit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final start = DateTime(now.year - 1, 1, 1);
      final months = List.generate(
        (now.year + 1 - start.year) * 12 + (now.month - start.month) + 1,
        (i) => DateTime(start.year, start.month + i, 1),
      );
      final currentMonthIndex = months.indexWhere(
        (m) => m.year == now.year && m.month == now.month,
      );
      if (currentMonthIndex >= 0 && _scrollController.isAttached) {
        _scrollController.scrollTo(
          index: currentMonthIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          alignment: 0.5, // ✅ centre le mois au milieu
        );
      }
    });
  }

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  Future<void> _loadEvents() async {
    final entries = await _storage.loadAllEntries();
    final map = <DateTime, List>{};
    for (final e in entries) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      map.putIfAbsent(day, () => []).add(e);
    }
    setState(() => _events = map);
  }

  List eventsForDay(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return _events[d] ?? [];
  }

  bool _isFuture(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(day.year, day.month, day.day);
    return d.isAfter(today);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    final start = DateTime(now.year - 1, 1, 1);
    final end = DateTime(now.year + 1, 12, 31);
    final months = List.generate(
      (end.year - start.year) * 12 + (end.month - start.month) + 1,
      (i) => DateTime(start.year, start.month + i, 1),
    );

    return Scaffold(
      body: ScrollablePositionedList.builder(
        itemScrollController: _scrollController, // ✅ ajoute le contrôleur
        physics: const ClampingScrollPhysics(),
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat.yMMMM('fr_FR').format(month).toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                TableCalendar(
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2050, 12, 31),
                  focusedDay: month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  locale: 'fr_FR',
                  headerVisible: false,
                  calendarFormat: CalendarFormat.month,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  calendarStyle: const CalendarStyle(outsideDaysVisible: false),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final isFuture = _isFuture(day);
                      final hasSang = eventsForDay(day).any((e) {
                        try {
                          return e.bleeding != -1; // ✅ corrigé
                        } catch (_) {
                          return false;
                        }
                      });
                      return Opacity(
                        opacity: isFuture ? 0.55 : 1.0,
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: hasSang ? Colors.red : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  eventLoader: eventsForDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
