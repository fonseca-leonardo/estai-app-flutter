import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/anchor_alarm.dart';

class AnchorAlarmViewModel extends ChangeNotifier {
  static const String _prefsKey = 'anchor_alarm';
  static const _distanceCalc = Distance();

  AnchorAlarm? _alarm;
  bool _isSettingAnchor = false;
  bool _isAlarmTriggered = false;

  // Extensível para notificações locais no futuro (background)
  VoidCallback? onAlarmTriggered;
  VoidCallback? onAlarmRestored;

  AnchorAlarm? get alarm => _alarm;
  bool get isSettingAnchor => _isSettingAnchor;
  bool get isAlarmTriggered => _isAlarmTriggered;
  bool get isActive => _alarm != null;

  AnchorAlarmViewModel() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      _alarm = AnchorAlarm.fromMap(jsonDecode(raw));
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    if (_alarm != null) {
      await prefs.setString(_prefsKey, jsonEncode(_alarm!.toMap()));
    } else {
      await prefs.remove(_prefsKey);
    }
  }

  void setSettingAnchorMode(bool value) {
    _isSettingAnchor = value;
    notifyListeners();
  }

  Future<void> setAlarm(LatLng point, double radiusMeters) async {
    _alarm = AnchorAlarm(
      latitude: point.latitude,
      longitude: point.longitude,
      radiusMeters: radiusMeters,
    );
    _isSettingAnchor = false;
    _isAlarmTriggered = false;
    await _persist();
    notifyListeners();
  }

  Future<void> clearAlarm() async {
    final wasTriggered = _isAlarmTriggered;
    _alarm = null;
    _isSettingAnchor = false;
    _isAlarmTriggered = false;
    await _persist();
    notifyListeners();
    if (wasTriggered) onAlarmRestored?.call();
  }

  void dismissTrigger() {
    _isAlarmTriggered = false;
    notifyListeners();
    onAlarmRestored?.call();
  }

  void checkPosition(LatLng userPosition) {
    if (_alarm == null) return;

    final anchorPoint = LatLng(_alarm!.latitude, _alarm!.longitude);
    final dist = _distanceCalc(anchorPoint, userPosition);

    if (dist > _alarm!.radiusMeters) {
      if (!_isAlarmTriggered) {
        _isAlarmTriggered = true;
        notifyListeners();
        onAlarmTriggered?.call();
      }
    } else {
      if (_isAlarmTriggered) {
        _isAlarmTriggered = false;
        notifyListeners();
        onAlarmRestored?.call();
      }
    }
  }
}
