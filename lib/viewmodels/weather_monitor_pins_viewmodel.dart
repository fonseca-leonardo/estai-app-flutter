import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_monitor_pin.dart';

class WeatherMonitorPinsViewModel extends ChangeNotifier {
  static const String _localPinsKey = 'weather_monitor_pins';

  List<WeatherMonitorPin> _pins = [];
  bool _isLoading = false;
  bool _isAddingPin = false;
  String? _errorMessage;

  List<WeatherMonitorPin> get pins => _pins;
  bool get isLoading => _isLoading;
  bool get isAddingPin => _isAddingPin;
  String? get errorMessage => _errorMessage;

  WeatherMonitorPinsViewModel() {
    _loadPins();
  }

  Future<void> _loadPins() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final localPinsJson = prefs.getString(_localPinsKey);

      if (localPinsJson == null || localPinsJson.isEmpty) {
        _pins = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      final List<dynamic> pinsList = json.decode(localPinsJson);
      _pins = pinsList
          .map((pinMap) => WeatherMonitorPin.fromMap(
                pinMap as Map<String, dynamic>,
              ))
          .toList();

      _pins.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _pins = [];
      _errorMessage = 'Error loading pins: $e';
      debugPrint('Error loading pins from local storage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _savePins() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pinsList = _pins.map((pin) => pin.toMap()).toList();
      await prefs.setString(_localPinsKey, json.encode(pinsList));
    } catch (e) {
      _errorMessage = 'Error saving pins: $e';
      debugPrint('Error saving pins to local storage: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addPin(String name, double latitude, double longitude) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final pinId = now.millisecondsSinceEpoch.toString();

      final pin = WeatherMonitorPin(
        id: pinId,
        name: name,
        latitude: latitude,
        longitude: longitude,
        createdAt: now,
      );

      _pins.add(pin);
      _pins.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      await _savePins();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error adding pin: $e';
      debugPrint('Error in addPin: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removePin(String pinId) async {
    _errorMessage = null;
    notifyListeners();

    try {
      _pins.removeWhere((pin) => pin.id == pinId);
      await _savePins();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error removing pin: $e';
      debugPrint('Error in removePin: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePinName(String pinId, String newName) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final pinIndex = _pins.indexWhere((pin) => pin.id == pinId);
      if (pinIndex != -1) {
        final oldPin = _pins[pinIndex];
        _pins[pinIndex] = WeatherMonitorPin(
          id: oldPin.id,
          name: newName,
          latitude: oldPin.latitude,
          longitude: oldPin.longitude,
          createdAt: oldPin.createdAt,
        );
        await _savePins();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error updating pin: $e';
      debugPrint('Error in updatePinName: $e');
      notifyListeners();
      rethrow;
    }
  }

  void setAddingPinMode(bool isAdding) {
    _isAddingPin = isAdding;
    notifyListeners();
  }

  WeatherMonitorPin? getPinById(String pinId) {
    try {
      return _pins.firstWhere((pin) => pin.id == pinId);
    } catch (e) {
      return null;
    }
  }
}
