import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/map_item.dart';
import '../services/maps_service.dart';
import '../services/maps_api_client.dart';

class ListMapsViewModel extends ChangeNotifier {
  final MapsService _mapsService;
  static const String _selectedMapIdsKey = 'selected_map_ids';

  List<MapItem> _maps = [];
  bool _isLoading = false;
  String? _errorMessage;
  Set<String> _selectedMapIds = {};

  ListMapsViewModel({MapsService? mapsService})
    : _mapsService = mapsService ?? MapsService() {
    _loadSelectedMaps();
    loadMaps();
  }

  List<MapItem> get maps => _maps;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Set<String> get selectedMapIds => Set.unmodifiable(_selectedMapIds);

  List<MapItem> get selectedMaps {
    return _maps.where((map) => _selectedMapIds.contains(map.id)).toList();
  }

  bool isMapSelected(String mapId) {
    return _selectedMapIds.contains(mapId);
  }

  Future<void> loadMaps() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _maps = await _mapsService.getMaps();
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = 'Error loading maps: ${e.message}';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading maps: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSelectedMaps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final selectedIdsJson = prefs.getString(_selectedMapIdsKey);
      if (selectedIdsJson != null) {
        final List<dynamic> decoded = json.decode(selectedIdsJson);
        _selectedMapIds = decoded.map((id) => id.toString()).toSet();
        notifyListeners();
      }
    } catch (e) {
      _selectedMapIds = {};
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

  Future<void> toggleMapSelection(String mapId) async {
    if (_selectedMapIds.contains(mapId)) {
      _selectedMapIds.remove(mapId);
    } else {
      _selectedMapIds.add(mapId);
    }
    notifyListeners();
    await _saveSelectedMaps();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
