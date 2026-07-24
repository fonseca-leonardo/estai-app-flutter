import 'package:flutter/foundation.dart';

import '../services/boat_cache_service.dart';
import '../services/marina_monitoring_service.dart';
import '../services/marina_storage_service.dart';
import 'map_viewmodel.dart';
import 'navigation_status_viewmodel.dart';

/// Faz a ponte entre o estado de navegação/posição e a monitoria da marina:
/// quando uma navegação inicia e existe marina + barco de monitoria definidos,
/// liga o [MarinaMonitoringService] e repassa as posições do [MapViewModel].
class MarinaMonitoringViewModel extends ChangeNotifier {
  final MarinaMonitoringService _service;
  final NavigationStatusViewModel _navigation;
  final MapViewModel _map;
  final MarinaStorageService _marinaStorage;
  final BoatCacheService _boatCache;

  bool _wasNavigating = false;

  double? _lastSentLatitude;
  double? _lastSentLongitude;
  double? _lastSentHeading;
  double? _lastSentSpeed;
  DateTime? _lastSentTimestamp;

  MarinaMonitoringViewModel({
    required NavigationStatusViewModel navigation,
    required MapViewModel map,
    MarinaMonitoringService? service,
    MarinaStorageService? marinaStorage,
    BoatCacheService? boatCache,
  }) : _service = service ?? MarinaMonitoringService(),
       _navigation = navigation,
       _map = map,
       _marinaStorage = marinaStorage ?? MarinaStorageService(),
       _boatCache = boatCache ?? BoatCacheService() {
    _navigation.addListener(_onNavigationChanged);
    _map.addListener(_onMapChanged);
    _service.addListener(_onServiceChanged);
    _wasNavigating = _navigation.isNavigating;
    if (_wasNavigating) {
      _startMonitoring();
    }
  }

  MarinaMonitoringState get state => _service.state;
  bool get isConnected => _service.isConnected;
  String? get lastError => _service.lastError;

  void _onNavigationChanged() {
    final isNavigating = _navigation.isNavigating;
    if (isNavigating == _wasNavigating) return;
    _wasNavigating = isNavigating;

    if (isNavigating) {
      _startMonitoring();
    } else {
      _stopMonitoring();
    }
  }

  Future<void> _startMonitoring() async {
    try {
      final marina = await _marinaStorage.getSaved();
      final boat = await _boatCache.getActiveMonitoringBoat();
      if (marina == null || boat == null) return;
      // Só barcos associados à marina atual podem ser monitorados (cobre
      // também o resume de navegação após a associação ser desfeita).
      if (boat.marinaId != marina.id) return;
      if (!_navigation.isNavigating) return;

      await _service.start(marinaId: marina.id, boat: boat);
    } catch (e) {
      debugPrint('MarinaMonitoringViewModel: falha ao iniciar monitoria - $e');
    }
  }

  Future<void> _stopMonitoring() async {
    try {
      await _service.stop();
      await _boatCache.clearActiveMonitoringBoat();
    } catch (e) {
      debugPrint('MarinaMonitoringViewModel: falha ao parar monitoria - $e');
    }
  }

  void _onMapChanged() {
    if (!_service.isConnected) return;

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
    _service.publishPosition(
      latitude: position.latitude,
      longitude: position.longitude,
      heading: position.heading,
      speed: position.speed,
    );
  }

  void _onServiceChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _navigation.removeListener(_onNavigationChanged);
    _map.removeListener(_onMapChanged);
    _service.removeListener(_onServiceChanged);
    _service.dispose();
    super.dispose();
  }
}
