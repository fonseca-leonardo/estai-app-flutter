import 'package:flutter/foundation.dart';

import '../services/signalk_service.dart';
import 'map_viewmodel.dart';
import 'signalk_configuration_viewmodel.dart';

class SignalKConnectionViewModel extends ChangeNotifier {
  final SignalKService _service;
  final SignalKConfigurationViewModel _config;
  final MapViewModel _map;

  double? _lastSentLatitude;
  double? _lastSentLongitude;
  double? _lastSentHeading;
  double? _lastSentSpeed;
  DateTime? _lastSentTimestamp;

  SignalKConnectionViewModel({
    required SignalKConfigurationViewModel config,
    required MapViewModel map,
    SignalKService? service,
  }) : _service = service ?? SignalKService(),
       _config = config,
       _map = map {
    _config.addListener(_onConfigChanged);
    _map.addListener(_onMapChanged);
    _service.addListener(_onServiceChanged);
    _onConfigChanged();
  }

  SignalKConnectionState get state => _service.state;
  bool get isConnected => _service.isConnected;
  String? get lastError => _service.lastError;

  void _onConfigChanged() {
    if (_config.isLoading) return;
    _service.configure(host: _config.host, token: _config.token);
  }

  void _onMapChanged() {
    final position = _map.currentPosition;

    if (position == null) return;

    if (_lastSentLatitude == position.latitude &&
        _lastSentLongitude == position.longitude &&
        _lastSentHeading == position.heading &&
        _lastSentSpeed == position.speed &&
        _lastSentTimestamp == position.timestamp) {
      return;
    }

    _lastSentLatitude = position.latitude;
    _lastSentLongitude = position.longitude;
    _lastSentHeading = position.heading;
    _lastSentSpeed = position.speed;
    _lastSentTimestamp = position.timestamp;
    _service.sendNavigation(
      latitude: position.latitude,
      longitude: position.longitude,
      headingDegrees: position.heading,
      speedMetersPerSecond: position.speed,
      timestamp: position.timestamp,
    );
  }

  void _onServiceChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _config.removeListener(_onConfigChanged);
    _map.removeListener(_onMapChanged);
    _service.removeListener(_onServiceChanged);
    _service.dispose();
    super.dispose();
  }
}
