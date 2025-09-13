import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_entry.dart';

class StorageService {
  static const String prefix = 'entry_';

  Future<void> saveEntry(DailyEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyForDate(entry.date);
    await prefs.setString(key, jsonEncode(entry.toJson()));
  }

  Future<DailyEntry?> loadEntryForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyForDate(date);
    if (!prefs.containsKey(key)) return null;
    final payload = prefs.getString(key)!;
    final json = jsonDecode(payload) as Map<String, dynamic>;
    return DailyEntry.fromJson(json);
  }

  String _keyForDate(DateTime date) {
    final ymd = DateFormat('yyyy-MM-dd').format(date);
    return '$prefix$ymd';
  }
}
