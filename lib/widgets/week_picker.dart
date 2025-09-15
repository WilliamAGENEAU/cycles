import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class WeekPicker extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final Future<void> Function(DateTime)? onLoadForDate;

  const WeekPicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.onLoadForDate,
  });

  @override
  State<WeekPicker> createState() => _WeekPickerState();
}

class _WeekPickerState extends State<WeekPicker> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDate;
    _selectedDay = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 100, // 👈 empêche l'overflow
      child: TableCalendar(
        locale: 'fr_FR',
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: CalendarFormat.week,
        availableCalendarFormats: const {CalendarFormat.week: 'Semaine'},
        headerVisible: false,
        daysOfWeekVisible: false,
        startingDayOfWeek: StartingDayOfWeek.monday,
        rowHeight: 70,

        // --- Style global
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultDecoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(12),
          ),
          weekendDecoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(12),
          ),
          todayDecoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.primary, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
          ),
          selectedDecoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          defaultTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          todayTextStyle: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        // --- Builder custom : lettre du jour + numéro
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return _buildDayBox(day, theme, isToday: false, isSelected: false);
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildDayBox(day, theme, isToday: true, isSelected: false);
          },
          selectedBuilder: (context, day, focusedDay) {
            return _buildDayBox(
              day,
              theme,
              isToday: isSameDay(day, DateTime.now()),
              isSelected: true,
            );
          },
        ),

        onDaySelected: (selectedDay, focusedDay) async {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          widget.onDateSelected(selectedDay);
          if (widget.onLoadForDate != null) {
            await widget.onLoadForDate!(selectedDay);
          }
        },
      ),
    );
  }

  Widget _buildDayBox(
    DateTime day,
    ThemeData theme, {
    required bool isToday,
    required bool isSelected,
  }) {
    final String letter = DateFormat.E(
      'fr_FR',
    ).format(day).substring(0, 1).toUpperCase();
    final String number = day.day.toString();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primary : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? Border.all(color: theme.colorScheme.primary, width: 2)
            : null,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              letter,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              number,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
