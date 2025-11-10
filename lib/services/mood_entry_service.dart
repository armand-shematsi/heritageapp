import '../models/mood_entry.dart';
import 'api_service.dart';

class MoodEntryService {
  final ApiService _api = ApiService();

  Future<List<MoodEntry>> getMoodEntries() async {
    try {
      final response = await _api.get('/mood-entries');
      if (response is List) {
        return response.map((json) => MoodEntry.fromJson(json)).toList();
      } else if (response['data'] != null) {
        return (response['data'] as List)
            .map((json) => MoodEntry.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching mood entries: $e');
      return [];
    }
  }

  Future<MoodEntry?> createMoodEntry({
    required int moodRating,
    String? notes,
    DateTime? date,
    List<String>? tags,
  }) async {
    try {
      final response = await _api.post('/mood-entries', {
        'mood_rating': moodRating,
        'notes': notes ?? '',
        'date': (date ?? DateTime.now()).toIso8601String().split('T')[0],
        'tags': tags ?? [],
      });
      return MoodEntry.fromJson(response);
    } catch (e) {
      print('Error creating mood entry: $e');
      return null;
    }
  }

  Future<bool> updateMoodEntry(String id, {
    int? moodRating,
    String? notes,
    DateTime? date,
    List<String>? tags,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (moodRating != null) data['mood_rating'] = moodRating;
      if (notes != null) data['notes'] = notes;
      if (date != null) data['date'] = date.toIso8601String().split('T')[0];
      if (tags != null) data['tags'] = tags;

      await _api.put('/mood-entries/$id', data);
      return true;
    } catch (e) {
      print('Error updating mood entry: $e');
      return false;
    }
  }

  Future<bool> deleteMoodEntry(String id) async {
    try {
      await _api.delete('/mood-entries/$id');
      return true;
    } catch (e) {
      print('Error deleting mood entry: $e');
      return false;
    }
  }
}

