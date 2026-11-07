import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/checklist.dart';
import '../models/checklist_trigger.dart';

/// Checklists ficam só no aparelho: funcionam offline e sem login, já que
/// são abertos no início e no fim da navegação.
class ChecklistStorageService {
  static const String _checklistsKey = 'checklists';
  static const String _seededKey = 'checklists_seeded';

  Future<List<Checklist>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_checklistsKey);
    if (raw == null) return [];

    try {
      final data = json.decode(raw) as List<dynamic>;
      return data
          .map((item) => Checklist.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Dado corrompido não pode travar a navegação.
      return [];
    }
  }

  /// Checklists com o vínculo [trigger] que tenham ao menos um item.
  Future<List<Checklist>> getByTrigger(ChecklistTrigger trigger) async {
    final all = await getAll();
    return all
        .where((checklist) => checklist.trigger == trigger)
        .where((checklist) => checklist.items.isNotEmpty)
        .toList();
  }

  /// Cria ou atualiza (pelo `id`).
  Future<void> save(Checklist checklist) async {
    final all = await getAll();
    final index = all.indexWhere((item) => item.id == checklist.id);
    if (index >= 0) {
      all[index] = checklist;
    } else {
      all.add(checklist);
    }
    await _write(all);
  }

  Future<void> delete(String id) async {
    final all = await getAll();
    all.removeWhere((item) => item.id == id);
    await _write(all);
  }

  /// Grava os [defaults] uma única vez. Se o usuário apagar os modelos,
  /// eles não voltam.
  Future<void> ensureDefaults(List<Checklist> Function() defaults) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_seededKey) ?? false) return;

    final all = await getAll();
    await _write([...all, ...defaults()]);
    await prefs.setBool(_seededKey, true);
  }

  Future<void> _write(List<Checklist> checklists) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _checklistsKey,
      json.encode(checklists.map((item) => item.toJson()).toList()),
    );
  }
}
