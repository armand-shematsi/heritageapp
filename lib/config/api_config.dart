class ApiConfig {
  // Update this to your Laravel backend URL
  // For local development, use: http://10.0.2.2:8000 (Android emulator)
  // or http://localhost:8000 (iOS simulator/Web)
  // For physical device, use your computer's IP address: http://192.168.x.x:8000
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Headers
  static Map<String, String> getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}

