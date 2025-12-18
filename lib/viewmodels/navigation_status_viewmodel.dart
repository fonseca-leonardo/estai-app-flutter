import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'settings_viewmodel.dart';

class NavigationStatusViewModel extends ChangeNotifier {
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isNavigating = false;
  DateTime? _startTime;
  List<LatLng> _trackedRoute = [];
  SettingsViewModel? _settingsViewModel;

  Duration get elapsedTime => _elapsedTime;
  bool get isNavigating => _isNavigating;
  List<LatLng> get trackedRoute => _trackedRoute;

  void setSettingsViewModel(SettingsViewModel settingsViewModel) {
    _settingsViewModel?.removeListener(_onSettingsChanged);
    _settingsViewModel = settingsViewModel;
    _settingsViewModel?.addListener(_onSettingsChanged);
  }

  void _onSettingsChanged() {
    notifyListeners();
  }

  double get _minimumDistanceMeters {
    return _settingsViewModel?.minimumDistanceMeters ?? 50.0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _settingsViewModel?.removeListener(_onSettingsChanged);
    super.dispose();
  }

  String get formattedTime {
    final hours = _elapsedTime.inHours.toString().padLeft(2, '0');
    final minutes = (_elapsedTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsedTime.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  double _calculateTotalDistance() {
    if (_trackedRoute.length < 2) {
      return 0.0;
    }

    const distance = Distance();
    double totalDistance = 0.0;

    for (int i = 0; i < _trackedRoute.length - 1; i++) {
      totalDistance += distance.as(
        LengthUnit.Meter,
        _trackedRoute[i],
        _trackedRoute[i + 1],
      );
    }

    return totalDistance;
  }

  String get formattedDistance {
    const metersPerNauticalMile = 1852.0;
    final distanceInMeters = _calculateTotalDistance();
    final nauticalMiles = distanceInMeters / metersPerNauticalMile;
    return '${nauticalMiles.toStringAsFixed(2)} NM';
  }

  void startNavigation() {
    if (_isNavigating) return;

    _isNavigating = true;
    _startTime = DateTime.now();
    _trackedRoute.clear();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        _elapsedTime = DateTime.now().difference(_startTime!);
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void addTrackedPoint(LatLng point) {
    if (!_isNavigating) return;

    if (_trackedRoute.isEmpty) {
      _trackedRoute = [point];
      notifyListeners();
      return;
    }

    const distance = Distance();
    final lastPoint = _trackedRoute.last;
    final distanceToLastPoint = distance.as(LengthUnit.Meter, lastPoint, point);

    if (distanceToLastPoint >= _minimumDistanceMeters) {
      _trackedRoute = [..._trackedRoute, point];
      notifyListeners();
    }
  }

  void stopNavigation() {
    _timer?.cancel();
    _timer = null;
    _isNavigating = false;
    notifyListeners();
  }

  void resetNavigation() {
    _timer?.cancel();
    _timer = null;
    _elapsedTime = Duration.zero;
    _isNavigating = false;
    _startTime = null;
    _trackedRoute.clear();
    notifyListeners();
  }
}
