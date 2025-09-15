// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DailyEntry {
  final DateTime date;
  final double? temperature;
  final int bleeding; // -1 = none, 0..3 otherwise
  final List<String> mucus; // could be single element for single selection
  final List<String> pain; // multi
  final List<String> mood; // multi
  final String notes;

  DailyEntry({
    required this.date,
    this.temperature,
    this.bleeding = -1,
    this.mucus = const [],
    this.pain = const [],
    this.mood = const [],
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'temperature': temperature,
    'bleeding': bleeding,
    'mucus': mucus,
    'pain': pain,
    'mood': mood,
    'notes': notes,
  };

  factory DailyEntry.fromJson(Map<String, dynamic> json) => DailyEntry(
    date: DateTime.parse(json['date']),
    temperature: json['temperature'] == null
        ? null
        : (json['temperature'] as num).toDouble(),
    bleeding: json['bleeding'] ?? -1,
    mucus:
        (json['mucus'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
        [],
    pain:
        (json['pain'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
        [],
    mood:
        (json['mood'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
        [],
    notes: json['notes'] ?? '',
  );
}

class StorageService {
  static const String _prefix = 'entry_';

  static String _keyForDate(DateTime date) {
    final ymd = DateFormat('yyyy-MM-dd').format(date);
    return '$_prefix$ymd';
  }

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
    final map = jsonDecode(payload) as Map<String, dynamic>;
    return DailyEntry.fromJson(map);
  }

  Future<void> deleteEntryForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyForDate(date);
    if (prefs.containsKey(key)) await prefs.remove(key);
  }

  /// Load all stored entries (useful for calendar highlighting / analytics)
  Future<List<DailyEntry>> loadAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));
    final out = <DailyEntry>[];
    for (final k in keys) {
      try {
        final payload = prefs.getString(k);
        if (payload == null) continue;
        final map = jsonDecode(payload) as Map<String, dynamic>;
        out.add(DailyEntry.fromJson(map));
      } catch (_) {}
    }
    return out;
  }
}
