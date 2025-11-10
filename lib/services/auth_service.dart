import '../services/api_service.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? culturalBackground,
    String? currentLocation,
    List<String>? languages,
  }) async {
    final response = await _api.post('/register', {
      'name': name,
      'email': email,
      'password': password,
      'cultural_background': culturalBackground,
      'current_location': currentLocation,
      'languages': languages ?? ['English'],
    });

    if (response['access_token'] != null) {
      _api.setToken(response['access_token']);
    }

    return response;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _api.post('/login', {
      'email': email,
      'password': password,
    });

    if (response['access_token'] != null) {
      _api.setToken(response['access_token']);
    }

    return response;
  }

  Future<void> logout() async {
    try {
      await _api.post('/logout', {});
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _api.clearToken();
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _api.get('/user');
      return User.fromJson(response);
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  bool get isAuthenticated => _api.token != null;
}

