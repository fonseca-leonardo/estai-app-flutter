import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/estai_session.dart';
import 'api_exception.dart';

export 'api_exception.dart';

/// Cliente base para as APIs do Estai (`https://api.estai.com.br/estai-api`).
///
/// Fluxo de autenticação:
/// 1. Pega o ID token do Firebase do usuário logado.
/// 2. Faz `GET /me` com `Authorization: Bearer {firebaseIdToken}`.
/// 3. A API devolve um `accessToken` próprio do Estai (ver [EstaiSession]).
/// 4. Esse token passa a ser enviado como `Authorization: Bearer {accessToken}`
///    em todas as chamadas subsequentes.
///
/// Use a instância compartilhada [EstaiApiClient.instance] nos services. O
/// construtor público existe para permitir injeção de um [http.Client] em
/// testes.
class EstaiApiClient {
  /// Liga/desliga os logs de request/response no console. Altere aqui
  /// manualmente conforme a necessidade de debug.
  static bool enableRequestLogs = true;

  static const String baseUrl = kDebugMode
      ? 'http://192.168.68.105:3333/estai-app'
      : 'http://192.168.68.105:3333/estai-app';
  // : 'https://api.estai.com.br/estai-api'; // 'https://api.estai.com.br/estai-api';

  /// Instância compartilhada usada pelos services da aplicação.
  static final EstaiApiClient instance = EstaiApiClient();

  final String _baseUrl;
  final http.Client _client;
  final Map<String, String> _defaultHeaders;

  EstaiSession? _session;

  EstaiApiClient({
    http.Client? client,
    Map<String, String>? defaultHeaders,
    String? baseUrl,
  }) : _baseUrl = baseUrl ?? EstaiApiClient.baseUrl,
       _client = client ?? http.Client(),
       _defaultHeaders =
           defaultHeaders ??
           {'Content-Type': 'application/json', 'Accept': 'application/json'};

  /// Sessão atual do Estai, ou `null` se ainda não autenticado.
  EstaiSession? get session => _session;

  /// Token de acesso do Estai atualmente em uso.
  String? get accessToken => _session?.accessToken;

  bool get isAuthenticated => _session != null;

  /// Autentica no Estai trocando o ID token do Firebase por um access token
  /// próprio. Deve ser chamado após o login e ao entrar na tela de mapas.
  Future<EstaiSession> authenticate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw ApiException('Usuário não autenticado no Firebase');
    }

    final uri = Uri.parse('$_baseUrl/me');
    http.Response response;
    try {
      final firebaseToken = await user.getIdToken();
      if (firebaseToken == null) {
        throw ApiException('Não foi possível obter o token do Firebase');
      }
      final headers = Map<String, String>.from(_defaultHeaders)
        ..['Authorization'] = 'Bearer $firebaseToken';
      _logRequest('GET', uri);
      response = await _client.get(uri, headers: headers);
      _logResponse('GET', uri, response);
    } on ApiException {
      rethrow;
    } catch (e) {
      _logError('GET', uri, e);
      throw ApiException('Network error: $e', uri: uri);
    }

    if (response.statusCode != 200) {
      throw ApiException(
        'Falha ao autenticar no Estai: ${response.statusCode}',
        uri: uri,
        statusCode: response.statusCode,
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>;
      final session = EstaiSession.fromJson(data);
      _session = session;
      return session;
    } catch (e) {
      throw ApiException('Resposta inválida do endpoint /me: $e', uri: uri);
    }
  }

  /// Limpa a sessão em memória (usar no logout).
  void clearSession() {
    _session = null;
  }

  Map<String, String> _buildHeaders(Map<String, String>? additionalHeaders) {
    final headers = Map<String, String>.from(_defaultHeaders);
    final token = accessToken;
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  Uri _uri(String endpoint, [Map<String, dynamic>? queryParameters]) {
    var uri = Uri.parse('$_baseUrl$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      uri = uri.replace(
        queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }
    return uri;
  }

  void _logRequest(String method, Uri uri, {Object? body}) {
    if (!enableRequestLogs) return;
    debugPrint('[EstaiApiClient] → $method $uri${body != null ? ' | body: $body' : ''}');
  }

  void _logResponse(String method, Uri uri, http.Response response) {
    if (!enableRequestLogs) return;
    debugPrint(
      '[EstaiApiClient] ← $method $uri | status: ${response.statusCode} | body: ${response.body}',
    );
  }

  void _logError(String method, Uri uri, Object error) {
    if (!enableRequestLogs) return;
    debugPrint('[EstaiApiClient] ✗ $method $uri | error: $error');
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _uri(endpoint, queryParameters);
    _logRequest('GET', uri);
    try {
      final response = await _client.get(uri, headers: _buildHeaders(headers));
      _logResponse('GET', uri, response);
      return response;
    } catch (e) {
      _logError('GET', uri, e);
      throw ApiException('Network error: $e', uri: uri);
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = _uri(endpoint);
    _logRequest('POST', uri, body: body);
    try {
      final response = await _client.post(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? json.encode(body) : null,
      );
      _logResponse('POST', uri, response);
      return response;
    } catch (e) {
      _logError('POST', uri, e);
      throw ApiException('Network error: $e', uri: uri);
    }
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = _uri(endpoint);
    _logRequest('PUT', uri, body: body);
    try {
      final response = await _client.put(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? json.encode(body) : null,
      );
      _logResponse('PUT', uri, response);
      return response;
    } catch (e) {
      _logError('PUT', uri, e);
      throw ApiException('Network error: $e', uri: uri);
    }
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = _uri(endpoint);
    _logRequest('DELETE', uri, body: body);
    try {
      final response = await _client.delete(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? json.encode(body) : null,
      );
      _logResponse('DELETE', uri, response);
      return response;
    } catch (e) {
      _logError('DELETE', uri, e);
      throw ApiException('Network error: $e', uri: uri);
    }
  }

  void dispose() {
    _client.close();
  }
}
