import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/watch_connectivity_service.dart';
import 'map_viewmodel.dart';
import 'navigation_status_viewmodel.dart';

class WatchConnectivityViewModel extends ChangeNotifier {
  final WatchConnectivityService _watchService = WatchConnectivityService();
  Timer? _syncTimer;

  MapViewModel? _mapViewModel;
  NavigationStatusViewModel? _navigationViewModel;

  bool _isInitialized = false;
  bool get isWatchSupported => _watchService.isSupported;
  bool get isWatchPaired => _watchService.isPaired;
  bool get isWatchReachable => _watchService.isReachable;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _watchService.initialize();
    _isInitialized = true;
    notifyListeners();

    _startPeriodicSync();
  }

  void setViewModels({
    required MapViewModel mapViewModel,
    required NavigationStatusViewModel navigationViewModel,
  }) {
    _mapViewModel?.removeListener(_onDataChanged);
    _navigationViewModel?.removeListener(_onDataChanged);

    _mapViewModel = mapViewModel;
    _navigationViewModel = navigationViewModel;

    _mapViewModel?.addListener(_onDataChanged);
    _navigationViewModel?.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    _syncDataToWatch();
  }

  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _syncDataToWatch();
    });
  }

  Future<void> _syncDataToWatch() async {
    if (!_isInitialized ||
        _mapViewModel == null ||
        _navigationViewModel == null) {
      return;
    }

    await _watchService.checkReachability();

    final heading = _mapViewModel!.currentHeading;
    final speed = _mapViewModel!.currentSpeed;
    final distanceNM = _calculateDistanceInNauticalMiles();
    final isNavigating = _navigationViewModel!.isNavigating;

    await _watchService.sendNavigationData(
      heading: heading,
      speed: speed,
      distanceNauticalMiles: distanceNM,
      isNavigating: isNavigating,
    );

    await _watchService.updateApplicationContext(
      heading: heading,
      speed: speed,
      distanceNauticalMiles: distanceNM,
      isNavigating: isNavigating,
    );
  }

  double _calculateDistanceInNauticalMiles() {
    if (_navigationViewModel == null || !_navigationViewModel!.isNavigating) {
      return 0.0;
    }

    final distanceString = _navigationViewModel!.formattedDistance;
    final distanceValue = distanceString.replaceAll(' NM', '').trim();

    try {
      return double.parse(distanceValue);
    } catch (e) {
      return 0.0;
    }
  }

  Future<void> forceSync() async {
    await _syncDataToWatch();
    notifyListeners();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _syncTimer = null;
    _mapViewModel?.removeListener(_onDataChanged);
    _navigationViewModel?.removeListener(_onDataChanged);
    _watchService.dispose();
    super.dispose();
  }
}
