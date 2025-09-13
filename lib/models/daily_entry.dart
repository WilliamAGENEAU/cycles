class DailyEntry {
  final DateTime date;
  final double temperature;
  final int bleedingLevel; // 0..3
  final String mucus; // string label
  final String pain; // string label
  final String mood; // string label
  final String notes;

  DailyEntry({
    required this.date,
    required this.temperature,
    required this.bleedingLevel,
    required this.mucus,
    required this.pain,
    required this.mood,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'temperature': temperature,
    'bleedingLevel': bleedingLevel,
    'mucus': mucus,
    'pain': pain,
    'mood': mood,
    'notes': notes,
  };

  factory DailyEntry.fromJson(Map<String, dynamic> json) => DailyEntry(
    date: DateTime.parse(json['date']),
    temperature: (json['temperature'] as num).toDouble(),
    bleedingLevel: json['bleedingLevel'],
    mucus: json['mucus'],
    pain: json['pain'],
    mood: json['mood'],
    notes: json['notes'] ?? '',
  );
}
