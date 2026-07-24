import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/boat.dart';

/// Persiste no dispositivo a lista de barcos do usuário e o último barco
/// selecionado para navegação, para que a seleção de barco e a monitoria da
/// marina funcionem sem depender de rede.
class BoatCacheService {
  static const String _boatsKey = 'cached_boats';
  static const String _lastSelectedBoatKey = 'last_selected_boat';
  static const String _activeMonitoringBoatKey = 'active_monitoring_boat';

  Future<void> saveBoats(List<Boat> boats) async {
    final prefs = await SharedPreferences.getInstance();
    final data = boats.map((boat) => boat.toJson()).toList();
    await prefs.setString(_boatsKey, json.encode(data));
  }

  Future<List<Boat>> getBoats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_boatsKey);
    if (raw == null) return [];

    try {
      final data = json.decode(raw) as List<dynamic>;
      return data
          .map((item) => Boat.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveLastSelectedBoat(Boat boat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSelectedBoatKey, json.encode(boat.toJson()));
  }

  Future<Boat?> getLastSelectedBoat() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastSelectedBoatKey);
    if (raw == null) return null;

    try {
      final data = json.decode(raw) as Map<String, dynamic>;
      return Boat.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Barco escolhido para a monitoria da navegação em andamento. Diferente do
  /// último selecionado (usado só para pré-seleção), esta chave representa a
  /// intenção da navegação atual: é gravada ao iniciar com monitoria, limpa ao
  /// iniciar sem monitoria e ao encerrar a navegação. Persistida para que o
  /// resume de navegação após restart do app retome a monitoria.
  Future<void> saveActiveMonitoringBoat(Boat boat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeMonitoringBoatKey, json.encode(boat.toJson()));
  }

  Future<Boat?> getActiveMonitoringBoat() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_activeMonitoringBoatKey);
    if (raw == null) return null;

    try {
      final data = json.decode(raw) as Map<String, dynamic>;
      return Boat.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearActiveMonitoringBoat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeMonitoringBoatKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_boatsKey);
    await prefs.remove(_lastSelectedBoatKey);
    await prefs.remove(_activeMonitoringBoatKey);
  }
}
