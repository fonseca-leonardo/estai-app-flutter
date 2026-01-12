import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class MapsApiClient {
  static const String baseUrl = 'https://apps.estai.com.br/maps/api';

  final String _baseUrl;
  final http.Client _client;
  final Map<String, String> _defaultHeaders;

  MapsApiClient({
    http.Client? client,
    Map<String, String>? defaultHeaders,
    String? baseUrl,
  }) : _baseUrl = baseUrl ?? MapsApiClient.baseUrl,
       _client = client ?? http.Client(),
       _defaultHeaders =
           defaultHeaders ??
           {'Content-Type': 'application/json', 'Accept': 'application/json'};

  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? additionalHeaders,
  ) async {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken();
        if (token != null) {
          final existingCookie = headers['Cookie'] ?? '';
          if (existingCookie.isNotEmpty) {
            headers['Cookie'] = '$existingCookie; auth_token=$token';
          } else {
            headers['Cookie'] = 'auth_token=$token';
          }
        }
      } catch (e) {
        // Se houver erro ao obter o token, continua sem o cookie
      }
    }

    return headers;
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var uri = Uri.parse('$_baseUrl$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      uri = uri.replace(
        queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }

    try {
      final requestHeaders = await _buildHeaders(headers);
      final response = await _client.get(uri, headers: requestHeaders);
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
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final requestHeaders = await _buildHeaders(headers);
      final response = await _client.post(
        uri,
        headers: requestHeaders,
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
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final requestHeaders = await _buildHeaders(headers);
      final response = await _client.put(
        uri,
        headers: requestHeaders,
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
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final requestHeaders = await _buildHeaders(headers);
      final response = await _client.delete(uri, headers: requestHeaders);
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
