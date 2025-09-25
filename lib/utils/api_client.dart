import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiClient {
  Future<dynamic> get(String endpoint, {Map<String, String>? headers, Map<String, dynamic>? queryParams}) async {
    final uri = Uri.parse(ApiConfig.baseUrl + endpoint)
      .replace(queryParameters: queryParams?.map((k, v) => MapEntry(k, v.toString())));
    final response = await http.get(uri, headers: headers ?? ApiConfig.defaultHeaders)
      .timeout(ApiConfig.timeout);
    _handleError(response);
    return jsonDecode(response.body);
  }

  Future<dynamic> post(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final uri = Uri.parse(ApiConfig.baseUrl + endpoint);
    final response = await http.post(uri, headers: headers ?? ApiConfig.defaultHeaders, body: jsonEncode(body))
      .timeout(ApiConfig.timeout);
    _handleError(response);
    return jsonDecode(response.body);
  }

  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception('Failed: ${response.statusCode}, ${response.body}');
    }
  }
}
