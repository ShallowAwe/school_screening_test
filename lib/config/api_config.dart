class ApiConfig {
  static const String baseUrl = 'https://api.rbsknagpur.in';
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
  static const Duration timeout = Duration(seconds: 30);
}


