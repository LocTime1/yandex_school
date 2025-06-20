import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _http;
  final String baseUrl;
  final String apiKey;  

  ApiClient({
    required http.Client httpClient,
    required this.baseUrl,
    required this.apiKey,
  }) : _http = httpClient;

  Future<dynamic> get(String path, [Map<String,String>? query]) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    print(uri);
    final resp = await _http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',      
        'Accept': 'application/json',
      },
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('API GET $path → ${resp.statusCode}');
    }
    return jsonDecode(resp.body);
  }

   Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp = await _http.post(
      uri,
      headers: {
        'Authorization':   'Bearer $apiKey',
        'Content-Type':    'application/json',
        'Accept':          'application/json',
      },
      body: jsonEncode(body),
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('API POST $path → ${resp.statusCode}');
    }
    return jsonDecode(resp.body);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp = await _http.put(
      uri,
      headers: {
        'Authorization':   'Bearer $apiKey',
        'Content-Type':    'application/json',
        'Accept':          'application/json',
      },
      body: jsonEncode(body),
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('API PUT $path → ${resp.statusCode}');
    }
    return jsonDecode(resp.body);
  }

  Future<void> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp = await _http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Accept':        'application/json',
      },
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('API DELETE $path → ${resp.statusCode}');
    }
  }
}
