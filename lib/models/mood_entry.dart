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
}