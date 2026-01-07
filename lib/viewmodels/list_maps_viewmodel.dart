import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/map_item.dart';
import '../services/maps_service.dart';
import '../services/maps_api_client.dart';

class ListMapsViewModel extends ChangeNotifier {
  final MapsService _mapsService;
  static const String _selectedMapIdsKey = 'selected_map_ids';
  static const String _darkModeKey = 'map_dark_mode';

  List<MapItem> _maps = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isConnectionError = false;
  Set<String> _selectedMapIds = {};
  bool _darkMode = false;

  ListMapsViewModel({MapsService? mapsService})
    : _mapsService = mapsService ?? MapsService() {
    _loadSelectedMaps();
    _loadDarkModePreference();
    loadMaps();
  }

  List<MapItem> get maps => _maps;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isConnectionError => _isConnectionError;
  Set<String> get selectedMapIds => Set.unmodifiable(_selectedMapIds);
  bool get darkMode => _darkMode;

  List<MapItem> get primaryMaps {
    return _maps.where((map) => map.isPrimary).toList();
  }

  List<MapItem> get optionalMaps {
    return _maps.where((map) => !map.isPrimary).toList();
  }

  List<MapItem> get selectedMaps {
    final selected = _maps
        .where((map) => _selectedMapIds.contains(map.id))
        .toList();
    selected.sort((a, b) => a.priority.compareTo(b.priority));
    return selected;
  }

  bool isMapSelected(String mapId) {
    return _selectedMapIds.contains(mapId);
  }

  Future<void> loadMaps() async {
    _isLoading = true;
    _errorMessage = null;
    _isConnectionError = false;
    notifyListeners();

    try {
      _maps = await _mapsService.getMaps();
      _ensurePrimaryMapsSelected();
      _errorMessage = null;
      _isConnectionError = false;
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _isConnectionError = _isNetworkError(e.message);
      _errorMessage = _isConnectionError
          ? null
          : 'Error loading maps: ${e.message}';
      _isLoading = false;
      notifyListeners();
    } on SocketException {
      _isConnectionError = true;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      final errorString = e.toString();
      _isConnectionError = _isNetworkError(errorString);
      _errorMessage = _isConnectionError ? null : 'Error loading maps: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isNetworkError(String errorMessage) {
    final lowerMessage = errorMessage.toLowerCase();
    return lowerMessage.contains('host lookup') ||
        lowerMessage.contains('failed host lookup') ||
        lowerMessage.contains('nodename nor servname') ||
        lowerMessage.contains('network error') ||
        lowerMessage.contains('connection') ||
        lowerMessage.contains('socketexception') ||
        lowerMessage.contains('no internet') ||
        lowerMessage.contains('network is unreachable');
  }

  Future<void> _loadSelectedMaps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final selectedIdsJson = prefs.getString(_selectedMapIdsKey);
      if (selectedIdsJson != null) {
        final List<dynamic> decoded = json.decode(selectedIdsJson);
        _selectedMapIds = decoded.map((id) => id.toString()).toSet();
      }
      _ensurePrimaryMapsSelected();
    } catch (e) {
      _selectedMapIds = {};
      _ensurePrimaryMapsSelected();
    }
  }

  Future<void> _saveSelectedMaps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final selectedIdsJson = json.encode(_selectedMapIds.toList());
      await prefs.setString(_selectedMapIdsKey, selectedIdsJson);
    } catch (e) {
      // Ignora erros de persistência
    }
  }

  void _ensurePrimaryMapsSelected() {
    bool hasChanges = false;
    for (final map in _maps) {
      if (map.isPrimary && !_selectedMapIds.contains(map.id)) {
        _selectedMapIds.add(map.id);
        hasChanges = true;
      }
    }
    if (hasChanges) {
      notifyListeners();
      _saveSelectedMaps();
    }
  }

  Future<void> toggleMapSelection(String mapId) async {
    try {
      final map = _maps.firstWhere((m) => m.id == mapId);

      if (_selectedMapIds.contains(mapId)) {
        if (map.isPrimary) {
          return;
        }
        _selectedMapIds.remove(mapId);
      } else {
        _selectedMapIds.add(mapId);
      }
      notifyListeners();
      await _saveSelectedMaps();
    } catch (e) {
      return;
    }
  }

  Future<void> _loadDarkModePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _darkMode = prefs.getBool(_darkModeKey) ?? false;
      notifyListeners();
    } catch (e) {
      _darkMode = false;
    }
  }

  Future<void> _saveDarkModePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, _darkMode);
    } catch (e) {
      // Ignora erros de persistência
    }
  }

  Future<void> toggleDarkMode() async {
    _darkMode = !_darkMode;
    notifyListeners();
    await _saveDarkModePreference();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
