import 'dart:convert';
import 'package:http/http.dart' as http;

class MapsApiClient {
  static const String baseUrl = 'https://maps-api.estai.com.br/api';

  final http.Client _client;
  final Map<String, String> _defaultHeaders;

  MapsApiClient({http.Client? client, Map<String, String>? defaultHeaders})
    : _client = client ?? http.Client(),
      _defaultHeaders =
          defaultHeaders ??
          {'Content-Type': 'application/json', 'Accept': 'application/json'};

  Map<String, String> _buildHeaders(Map<String, String>? additionalHeaders) {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var uri = Uri.parse('$baseUrl$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      uri = uri.replace(
        queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }

    try {
      final response = await _client.get(uri, headers: _buildHeaders(headers));
      return response;
    } catch (e) {
      throw ApiException('Network error: $e', uri: uri);
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? json.encode(body) : null,
      );
      return response;
    } catch (e) {
      throw ApiException('Network error: $e', uri: uri);
    }
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await _client.put(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? json.encode(body) : null,
      );
      return response;
    } catch (e) {
      throw ApiException('Network error: $e', uri: uri);
    }
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await _client.delete(
        uri,
        headers: _buildHeaders(headers),
      );
      return response;
    } catch (e) {
      throw ApiException('Network error: $e', uri: uri);
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  final Uri? uri;
  final int? statusCode;

  ApiException(this.message, {this.uri, this.statusCode});

  @override
  String toString() {
    if (uri != null) {
      return 'ApiException: $message (URI: $uri)';
    }
    return 'ApiException: $message';
  }
}
