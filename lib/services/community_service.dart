import 'api_service.dart';

class CommunityService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> getForums() async {
    try {
      final response = await _api.get('/community/forums');
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      print('Error fetching forums: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPosts({String? forumId}) async {
    try {
      final endpoint = forumId != null 
          ? '/community/posts?forum_id=$forumId'
          : '/community/posts';
      final response = await _api.get(endpoint);
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createPost({
    required String forumId,
    required String title,
    required String content,
  }) async {
    try {
      final response = await _api.post('/community/posts', {
        'forum_id': forumId,
        'title': title,
        'content': content,
      });
      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('Error creating post: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendMessage(String forumId, String content) async {
    try {
      final response = await _api.post('/community/forums/$forumId/messages', {
        'content': content,
      });
      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }
}

