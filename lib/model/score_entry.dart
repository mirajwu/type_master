class ScoreEntry {
  final String username;
  final int wpm;
  final int errors;
  final String mode;
  final DateTime date;

  ScoreEntry({
    required this.username,
    required this.wpm,
    required this.errors,
    required this.mode,
    required this.date
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'wpm': wpm,
    'errors': errors,
    'mode': mode,
    'date': date.toIso8601String(),
  };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
    username: json['username'],
    wpm: json['wpm'],
    errors: json['errors'],
    mode: json['mode'],
    date: DateTime.parse(json['date']),
  );
}