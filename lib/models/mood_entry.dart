class MoodEntry {
  final String id;
  final String userId;
  final int moodRating;
  final String notes;
  final DateTime date;
  final List<String> tags;

  MoodEntry({
    required this.id,
    required this.userId,
    required this.moodRating,
    required this.notes,
    required this.date,
    this.tags = const [],
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      moodRating: json['mood_rating'] ?? 5,
      notes: json['notes'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : [],
    );
  }
}