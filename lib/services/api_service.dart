import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  String? get token => _token;

  void setToken(String? token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'An error occurred');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: ApiConfig.getHeaders(token: _token),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: ApiConfig.getHeaders(token: _token),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: ApiConfig.getHeaders(token: _token),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: ApiConfig.getHeaders(token: _token),
    );
    return _handleResponse(response);
  }
}

