import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/persisted_navigation.dart';
import '../models/trip_summary.dart';
import 'settings_viewmodel.dart';

class NavigationStatusViewModel extends ChangeNotifier {
  static const String _kActive = 'nav_active';
  static const String _kStartTime = 'nav_start_time';
  static const String _kTrackedRoute = 'nav_tracked_route';
  static const String _kPlannedRoute = 'nav_planned_route';
  static const String _kMaxSpeed = 'nav_max_speed';
  static const int _trackedSaveEveryNPoints = 5;
  static const Duration _expiration = Duration(hours: 24);
  static const double _metersPerNauticalMile = 1852.0;

  /// Abaixo disso a navegação não vira viagem no diário de bordo.
  static const Duration minTripDuration = Duration(minutes: 2);
  static const double minTripDistanceNm = 0.1;

  /// Leituras de GPS acima disso (~78 kn) são ruído e não contam como
  /// velocidade máxima.
  static const double _maxPlausibleSpeedMps = 40;

  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isNavigating = false;
  DateTime? _startTime;
  List<LatLng> _trackedRoute = [];
  SettingsViewModel? _settingsViewModel;
  int _pointsSinceLastSave = 0;
  double _maxSpeedMps = 0;

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
    final distanceInMeters = _calculateTotalDistance();
    final nauticalMiles = distanceInMeters / _metersPerNauticalMile;
    return '${nauticalMiles.toStringAsFixed(2)} NM';
  }

  void startNavigation({List<LatLng>? plannedRoute}) {
    if (_isNavigating) return;

    _isNavigating = true;
    _startTime = DateTime.now();
    _trackedRoute = [];
    _pointsSinceLastSave = 0;
    _maxSpeedMps = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        _elapsedTime = DateTime.now().difference(_startTime!);
        notifyListeners();
      }
    });
    notifyListeners();
    _persistStart(plannedRoute ?? const []);
  }

  /// [speedMps] é a velocidade do GPS nesta leitura; conta para a máxima
  /// mesmo quando o ponto não entra no trajeto (filtro de distância).
  void addTrackedPoint(LatLng point, {double? speedMps}) {
    if (!_isNavigating) return;

    if (speedMps != null &&
        speedMps > _maxSpeedMps &&
        speedMps <= _maxPlausibleSpeedMps) {
      _maxSpeedMps = speedMps;
    }

    if (_trackedRoute.isEmpty) {
      _trackedRoute = [point];
      _pointsSinceLastSave++;
      notifyListeners();
      _maybePersistTracked();
      return;
    }

    const distance = Distance();
    final lastPoint = _trackedRoute.last;
    final distanceToLastPoint = distance.as(LengthUnit.Meter, lastPoint, point);

    if (distanceToLastPoint >= _minimumDistanceMeters) {
      _trackedRoute = [..._trackedRoute, point];
      _pointsSinceLastSave++;
      notifyListeners();
      _maybePersistTracked();
    }
  }

  void stopNavigation() {
    _timer?.cancel();
    _timer = null;
    _isNavigating = false;
    _trackedRoute = [];
    notifyListeners();
    _clearPersisted();
  }

  void resetNavigation() {
    _timer?.cancel();
    _timer = null;
    _elapsedTime = Duration.zero;
    _isNavigating = false;
    _startTime = null;
    _trackedRoute = [];
    _pointsSinceLastSave = 0;
    _maxSpeedMps = 0;
    notifyListeners();
    _clearPersisted();
  }

  /// Encerra a navegação e devolve o resumo da viagem para o diário de
  /// bordo, ou `null` se foi curta demais ([minTripDuration],
  /// [minTripDistanceNm]). O resumo é montado antes de o trajeto ser limpo.
  TripSummary? finishNavigation({DateTime? now}) {
    final startedAt = _startTime;
    final summary = startedAt == null
        ? null
        : TripSummary(
            startedAt: startedAt,
            endedAt: now ?? DateTime.now(),
            track: List.of(_trackedRoute),
            distanceNm: _calculateTotalDistance() / _metersPerNauticalMile,
            maxSpeedKn: _maxSpeedMps > 0
                ? _maxSpeedMps * TripSummary.knotsPerMeterPerSecond
                : null,
          );

    stopNavigation();
    resetNavigation();

    if (summary == null ||
        summary.duration < minTripDuration ||
        summary.distanceNm < minTripDistanceNm) {
      return null;
    }
    return summary;
  }

  Future<PersistedNavigation?> loadPersistedNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    final active = prefs.getBool(_kActive) ?? false;
    if (!active) return null;

    final startRaw = prefs.getString(_kStartTime);
    if (startRaw == null) {
      await _clearPersisted();
      return null;
    }

    final startTime = DateTime.tryParse(startRaw);
    if (startTime == null) {
      await _clearPersisted();
      return null;
    }

    if (DateTime.now().difference(startTime) > _expiration) {
      await _clearPersisted();
      return null;
    }

    final tracked = PersistedNavigation.decodePoints(
      prefs.getString(_kTrackedRoute),
    );
    final planned = PersistedNavigation.decodePoints(
      prefs.getString(_kPlannedRoute),
    );

    return PersistedNavigation(
      startTime: startTime,
      trackedRoute: tracked,
      plannedRoute: planned,
      maxSpeedMps: prefs.getDouble(_kMaxSpeed),
    );
  }

  void resumeFromPersisted(PersistedNavigation snapshot) {
    if (_isNavigating) return;

    _isNavigating = true;
    _startTime = snapshot.startTime;
    _trackedRoute = List<LatLng>.from(snapshot.trackedRoute);
    _elapsedTime = DateTime.now().difference(snapshot.startTime);
    _pointsSinceLastSave = 0;
    _maxSpeedMps = snapshot.maxSpeedMps ?? 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        _elapsedTime = DateTime.now().difference(_startTime!);
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<void> discardPersisted() => _clearPersisted();

  Future<void> _persistStart(List<LatLng> plannedRoute) async {
    final startTime = _startTime;
    if (startTime == null) return;
    final prefs = await SharedPreferences.getInstance();
    // Encerrada enquanto o storage abria: não marcar como ativa.
    if (!_isNavigating) return;
    await prefs.setBool(_kActive, true);
    await prefs.setString(_kStartTime, startTime.toIso8601String());
    await prefs.setString(
      _kPlannedRoute,
      PersistedNavigation.encodePoints(plannedRoute),
    );
    await prefs.setString(
      _kTrackedRoute,
      PersistedNavigation.encodePoints(const []),
    );
  }

  Future<void> _maybePersistTracked() async {
    if (_pointsSinceLastSave < _trackedSaveEveryNPoints) return;
    _pointsSinceLastSave = 0;
    if (!_isNavigating) return;
    final prefs = await SharedPreferences.getInstance();
    if (!_isNavigating) return;
    await prefs.setString(
      _kTrackedRoute,
      PersistedNavigation.encodePoints(_trackedRoute),
    );
    await prefs.setDouble(_kMaxSpeed, _maxSpeedMps);
  }

  Future<void> flushTrackedRoute() async {
    if (!_isNavigating) return;
    _pointsSinceLastSave = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kTrackedRoute,
      PersistedNavigation.encodePoints(_trackedRoute),
    );
    await prefs.setDouble(_kMaxSpeed, _maxSpeedMps);
  }

  Future<void> _clearPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kActive);
    await prefs.remove(_kStartTime);
    await prefs.remove(_kTrackedRoute);
    await prefs.remove(_kPlannedRoute);
    await prefs.remove(_kMaxSpeed);
  }
}
