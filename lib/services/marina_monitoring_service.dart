import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:typed_data/typed_data.dart' as typed;

import '../models/boat.dart';
import 'estai_api_client.dart';

enum MarinaMonitoringState {
  disabled,
  connecting,
  connected,
  reconnecting,
  failed,
}

/// Publica a posição do barco no broker MQTT (EMQX) da marina enquanto uma
/// navegação está ativa. Send-only e totalmente silencioso: falhas nunca
/// propagam para a experiência de navegação — posições sem conexão são
/// descartadas e a reconexão acontece em background com backoff exponencial.
///
/// Convenção de conexão (alinhar com o backend): `clientId` = boatId,
/// `username` = userId, `password` = accessToken (JWT da estaiApi).
class MarinaMonitoringService extends ChangeNotifier {
  static const String brokerUrl = 'wss://emqx.coolify.estai.com.br/mqtt';
  static const int brokerPort = 443;

  static const Duration _minPublishInterval = Duration(seconds: 5);
  static const Duration _reauthCooldown = Duration(seconds: 60);
  static const int _maxBackoffSeconds = 30;
  static const int _keepAliveSeconds = 30;

  MqttServerClient? _client;
  Timer? _reconnectTimer;
  int _retryAttempt = 0;
  bool _active = false;
  bool _connecting = false;
  DateTime? _lastReauthAt;

  String? _marinaId;
  Boat? _boat;

  MarinaMonitoringState _state = MarinaMonitoringState.disabled;
  String? _lastError;
  DateTime? _lastPublishedAt;

  MarinaMonitoringState get state => _state;
  String? get lastError => _lastError;
  bool get isConnected => _state == MarinaMonitoringState.connected;

  String get _positionTopic => 'marina/$_marinaId/boats/${_boat?.id}/position';
  String get _statusTopic => 'marina/$_marinaId/boats/${_boat?.id}/status';

  /// Ativa a monitoria para o barco informado. Não lança exceções.
  Future<void> start({required String marinaId, required Boat boat}) async {
    _marinaId = marinaId;
    _boat = boat;
    _active = true;
    _retryAttempt = 0;
    await _connect();
  }

  /// Encerra a monitoria, publicando o status offline antes de desconectar.
  Future<void> stop() async {
    _active = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    if (isConnected) {
      _publishJson(_statusTopic, {
        'status': 'offline',
        'updatedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
      }, retain: true);
    }

    _disconnect();
    _marinaId = null;
    _boat = null;
    _lastError = null;
    _setState(MarinaMonitoringState.disabled);
  }

  /// Publica a posição atual do barco. Se a conexão não estiver ativa, a
  /// posição é descartada silenciosamente (sem fila offline).
  void publishPosition({
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
  }) {
    if (!isConnected || _boat == null) return;

    final now = DateTime.now();
    if (_lastPublishedAt != null &&
        now.difference(_lastPublishedAt!) < _minPublishInterval) {
      return;
    }
    _lastPublishedAt = now;

    _publishJson(_positionTopic, {
      'id': _boat!.id,
      'latitude': latitude,
      'longitude': longitude,
      if (heading != null && !heading.isNaN && heading >= 0) 'heading': heading,
      if (speed != null && !speed.isNaN && speed >= 0) 'speed': speed,
      'name': _boat!.name,
      'updatedAt': now.toUtc().millisecondsSinceEpoch,
    }, retain: false);
  }

  Future<void> _connect() async {
    if (!_active || _connecting) return;

    final accessToken = EstaiApiClient.instance.accessToken;
    final userId = EstaiApiClient.instance.session?.user.id;
    final boat = _boat;
    if (boat == null) return;

    _connecting = true;
    _setState(
      _retryAttempt == 0
          ? MarinaMonitoringState.connecting
          : MarinaMonitoringState.reconnecting,
    );

    _disposeClient();

    final client = MqttServerClient.withPort(brokerUrl, boat.id, brokerPort);
    client
      ..useWebSocket = true
      ..websocketProtocols = MqttConstants.protocolsSingleDefault
      ..keepAlivePeriod = _keepAliveSeconds
      ..autoReconnect = false
      ..logging(on: false)
      ..onDisconnected = _onDisconnected;

    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(boat.id)
        .startClean()
        .will()
        .withWillTopic(_statusTopic)
        .withWillPayload(_encodePayload({'status': 'offline'}))
        .withWillRetain()
        .withWillQos(MqttQos.atLeastOnce);

    _client = client;

    try {
      final status = await client.connect(userId, accessToken);
      _connecting = false;

      if (!_active) {
        _disconnect();
        return;
      }

      if (status?.state == MqttConnectionState.connected) {
        _retryAttempt = 0;
        _lastError = null;
        _setState(MarinaMonitoringState.connected);
        _publishJson(_statusTopic, {
          'status': 'online',
          'updatedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
        }, retain: true);
        return;
      }

      await _handleConnectFailure(status?.reasonCode);
    } catch (e) {
      _connecting = false;
      debugPrint('MarinaMonitoringService: falha ao conectar - $e');
      _lastError = e.toString();
      final reasonCode = _client?.connectionStatus?.reasonCode;
      await _handleConnectFailure(reasonCode);
    }
  }

  Future<void> _handleConnectFailure(MqttConnectReasonCode? reasonCode) async {
    _disconnect();
    if (!_active) return;

    final isAuthFailure =
        reasonCode == MqttConnectReasonCode.notAuthorized ||
        reasonCode == MqttConnectReasonCode.badUsernameOrPassword;

    if (isAuthFailure && _canAttemptReauth()) {
      _lastReauthAt = DateTime.now();
      try {
        await EstaiApiClient.instance.authenticate();
        _scheduleReconnect(immediate: true);
        return;
      } catch (e) {
        debugPrint('MarinaMonitoringService: falha ao re-autenticar - $e');
      }
    }

    _scheduleReconnect();
  }

  bool _canAttemptReauth() {
    final last = _lastReauthAt;
    return last == null || DateTime.now().difference(last) > _reauthCooldown;
  }

  void _onDisconnected() {
    if (_connecting || !_active) return;
    _lastError = 'Conexão encerrada pelo broker';
    _scheduleReconnect();
  }

  void _scheduleReconnect({bool immediate = false}) {
    if (!_active) return;
    _reconnectTimer?.cancel();
    final delay = immediate ? Duration.zero : _backoffFor(_retryAttempt);
    _retryAttempt++;
    _setState(MarinaMonitoringState.reconnecting);
    _reconnectTimer = Timer(delay, _connect);
  }

  Duration _backoffFor(int attempt) {
    final exponent = math.min(attempt, 5);
    final baseSeconds = math.min(1 << exponent, _maxBackoffSeconds);
    final baseMs = baseSeconds * 1000;
    final jitterRange = (baseMs * 0.2).round();
    final jitter = math.Random().nextInt(2 * jitterRange + 1) - jitterRange;
    return Duration(milliseconds: baseMs + jitter);
  }

  void _publishJson(
    String topic,
    Map<String, dynamic> payload, {
    bool retain = false,
  }) {
    try {
      _client?.publishMessage(
        topic,
        MqttQos.atMostOnce,
        _encodePayload(payload),
        retain: retain,
      );
    } catch (e) {
      debugPrint('MarinaMonitoringService: falha ao publicar - $e');
    }
  }

  typed.Uint8Buffer _encodePayload(Map<String, dynamic> payload) {
    return typed.Uint8Buffer()..addAll(utf8.encode(jsonEncode(payload)));
  }

  void _disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _disposeClient();
  }

  void _disposeClient() {
    final client = _client;
    _client = null;
    if (client == null) return;
    client.onDisconnected = null;
    try {
      client.disconnect();
    } catch (_) {}
  }

  void _setState(MarinaMonitoringState newState) {
    if (_state == newState) return;
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _active = false;
    _disconnect();
    super.dispose();
  }
}
