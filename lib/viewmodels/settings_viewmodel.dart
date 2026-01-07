import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  static const String _minimumDistanceKey = 'minimum_distance_meters';
  static const double _defaultMinimumDistance = 15.0;

  double _minimumDistanceMeters = _defaultMinimumDistance;
  bool _isLoading = true;

  double get minimumDistanceMeters => _minimumDistanceMeters;
  bool get isLoading => _isLoading;

  SettingsViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _minimumDistanceMeters =
          prefs.getDouble(_minimumDistanceKey) ?? _defaultMinimumDistance;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _minimumDistanceMeters = _defaultMinimumDistance;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setMinimumDistanceMeters(double value) async {
    if (_minimumDistanceMeters == value) return;

    _minimumDistanceMeters = value;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_minimumDistanceKey, value);
    } catch (e) {
      // Ignora erros de persistência
    }
  }
}
