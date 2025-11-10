import 'api_service.dart';

class EventService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      final response = await _api.get('/events');
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getEvent(String id) async {
    try {
      final response = await _api.get('/events/$id');
      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('Error fetching event: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createEvent(Map<String, dynamic> eventData) async {
    try {
      final response = await _api.post('/events', eventData);
      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('Error creating event: $e');
      return null;
    }
  }

  Future<bool> registerForEvent(String eventId) async {
    try {
      await _api.post('/events/$eventId/register', {});
      return true;
    } catch (e) {
      print('Error registering for event: $e');
      return false;
    }
  }
}

