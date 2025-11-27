import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO(radov): rewrite
class ApiClient {
  ApiClient({http.Client? client}) : _client = http.Client();

  final http.Client _client;
  final String baseUrl = 'https://example.com';

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final res = await _client.post(
      Uri.parse('$baseUrl$path'),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Request failed: ${res.statusCode}');
    }
  }

  Future<dynamic> get({
    String? path,
    String? fullPath,
    Map<String, String>? headers,
  }) async {
    final uri = fullPath ?? '$baseUrl$path';
    final res = await _client.get(Uri.parse(uri), headers: headers);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Request failed: ${res.statusCode}');
    }
  }
}
