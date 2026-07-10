import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum SignalKConnectionState {
  disabled,
  connecting,
  connected,
  reconnecting,
  failed,
}

class SignalKService extends ChangeNotifier {
  static const Duration _minSendInterval = Duration(milliseconds: 500);
  static const int _maxBackoffSeconds = 30;
  static const Duration _connectTimeout = Duration(seconds: 10);

  String? _host;
  String? _token;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _channelSubscription;
  Timer? _reconnectTimer;
  int _retryAttempt = 0;

  SignalKConnectionState _state = SignalKConnectionState.disabled;
  String? _lastError;
  DateTime? _lastSentAt;

  SignalKConnectionState get state => _state;
  String? get lastError => _lastError;
  bool get isConnected => _state == SignalKConnectionState.connected;

  void configure({required String host, required String token}) {
    final cleanHost = host.trim();
    final cleanToken = token.trim();

    if (cleanHost.isEmpty) {
      _host = null;
      _token = null;
      _disconnect();
      _setState(SignalKConnectionState.disabled);
      return;
    }

    final changed = _host != cleanHost || _token != cleanToken;
    _host = cleanHost;
    _token = cleanToken;

    if (changed) {
      _retryAttempt = 0;
      _disconnect();
      _connect();
    } else if (_state == SignalKConnectionState.disabled ||
        _state == SignalKConnectionState.failed) {
      _retryAttempt = 0;
      _connect();
    }
  }

  void sendNavigation({
    required double latitude,
    required double longitude,
    double? headingDegrees,
    double? speedMetersPerSecond,
    DateTime? timestamp,
  }) {
    if (_state != SignalKConnectionState.connected) return;

    final now = DateTime.now();
    if (_lastSentAt != null &&
        now.difference(_lastSentAt!) < _minSendInterval) {
      return;
    }
    _lastSentAt = now;

    final values = <Map<String, dynamic>>[
      {
        'path': 'navigation.position',
        'value': {'latitude': latitude, 'longitude': longitude},
      },
    ];

    if (headingDegrees != null &&
        !headingDegrees.isNaN &&
        headingDegrees >= 0) {
      final headingRadians = headingDegrees * math.pi / 180.0;
      values.add({
        'path': 'navigation.courseOverGroundTrue',
        'value': headingRadians,
      });
    }

    if (speedMetersPerSecond != null &&
        !speedMetersPerSecond.isNaN &&
        speedMetersPerSecond >= 0) {
      values.add({
        'path': 'navigation.speedOverGround',
        'value': speedMetersPerSecond,
      });
    }

    if (timestamp != null) {
      values.add({
        'path': 'navigation.datetime',
        'value': timestamp.toUtc().toIso8601String(),
      });
    }

    final payload = jsonEncode({
      'context': 'vessels.self',
      'updates': [
        {'values': values},
      ],
    });

    try {
      _channel?.sink.add(payload);
    } catch (e) {
      _handleFailure(e);
    }
  }

  Future<void> _connect() async {
    final host = _host;
    if (host == null || host.isEmpty) return;

    _setState(SignalKConnectionState.connecting);

    Uri uri;
    try {
      uri = _buildUri(host, _token);
    } catch (e) {
      _lastError = 'URL inválida: $e';
      _setState(SignalKConnectionState.failed);
      return;
    }

    try {
      final channel = WebSocketChannel.connect(uri);
      await channel.ready.timeout(_connectTimeout);
      _channel = channel;
      _retryAttempt = 0;
      _lastError = null;
      _setState(SignalKConnectionState.connected);

      _channelSubscription = channel.stream.listen(
        (_) {
          // Send-only client; ignore incoming messages.
        },
        onError: (Object error) {
          _handleFailure(error);
        },
        onDone: () {
          _handleClose(channel.closeCode, channel.closeReason);
        },
        cancelOnError: true,
      );
    } catch (e) {
      _handleFailure(e);
    }
  }

  void _handleClose(int? closeCode, String? closeReason) {
    if (_isAuthFailure(closeCode, closeReason)) {
      _lastError = 'Token inválido ou não autorizado';
      _disconnect();
      _setState(SignalKConnectionState.failed);
      return;
    }
    _lastError = closeReason ?? 'Conexão encerrada (código $closeCode)';
    _disconnect();
    _scheduleReconnect();
  }

  void _handleFailure(Object error) {
    final message = error.toString();
    _lastError = message;
    if (_isAuthFailureMessage(message)) {
      _disconnect();
      _setState(SignalKConnectionState.failed);
      return;
    }
    _disconnect();
    _scheduleReconnect();
  }

  bool _isAuthFailure(int? closeCode, String? closeReason) {
    if (closeCode == 4401 || closeCode == 4403) return true;
    final reason = (closeReason ?? '').toLowerCase();
    return reason.contains('unauthorized') || reason.contains('forbidden');
  }

  bool _isAuthFailureMessage(String message) {
    final lower = message.toLowerCase();
    return lower.contains('401') ||
        lower.contains('403') ||
        lower.contains('unauthorized') ||
        lower.contains('forbidden');
  }

  void _scheduleReconnect() {
    if (_host == null) return;
    _reconnectTimer?.cancel();
    final delay = _backoffFor(_retryAttempt);
    _retryAttempt++;
    _setState(SignalKConnectionState.reconnecting);
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

  Uri _buildUri(String host, String? token) {
    final useTls = host.startsWith('wss://') || host.startsWith('https://');
    final scheme = useTls ? 'wss' : 'ws';
    final cleanHost = host.replaceFirst(
      RegExp(r'^(wss?|https?)://', caseSensitive: false),
      '',
    );
    return Uri.parse('$scheme://$cleanHost/signalk/v1/stream').replace(
      queryParameters: {
        'subscribe': 'none',
        if (token != null && token.isNotEmpty) 'token': token,
      },
    );
  }

  void _disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _channelSubscription?.cancel();
    _channelSubscription = null;
    try {
      _channel?.sink.close();
    } catch (_) {}
    _channel = null;
  }

  void _setState(SignalKConnectionState newState) {
    if (_state == newState) return;
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _disconnect();
    super.dispose();
  }
}
