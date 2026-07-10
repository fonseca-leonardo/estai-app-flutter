import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/marina.dart';

/// Persiste no dispositivo os dados da marina associada ao usuário, para que
/// o `marinaId` e o fato de o usuário já estar associado a uma marina possam
/// ser consultados por outros fluxos do app sem depender de rede.
class MarinaStorageService {
  static const String _key = 'marina_data';

  Future<void> save(Marina marina) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(marina.toStorageJson()));
  }

  Future<Marina?> getSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;

    try {
      final data = json.decode(raw) as Map<String, dynamic>;
      return Marina.fromStorageJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasMarina() async {
    final marina = await getSaved();
    return marina != null;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
