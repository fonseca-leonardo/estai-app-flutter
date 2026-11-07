import 'package:flutter/foundation.dart';
import '../models/checklist.dart';
import '../models/checklist_trigger.dart';
import '../services/checklist_storage_service.dart';

/// Lista de checklists do aparelho, agrupada por vínculo.
///
/// Criada pela própria tela (escopo de tela).
class ChecklistsViewModel extends ChangeNotifier {
  ChecklistsViewModel({ChecklistStorageService? storage})
    : _storage = storage ?? ChecklistStorageService();

  final ChecklistStorageService _storage;

  List<Checklist> _checklists = [];
  bool _isLoading = false;

  List<Checklist> get checklists => List.unmodifiable(_checklists);
  bool get isLoading => _isLoading;
  bool get isEmpty => _checklists.isEmpty;

  List<Checklist> byTrigger(ChecklistTrigger trigger) =>
      _checklists.where((checklist) => checklist.trigger == trigger).toList();

  /// [defaults] monta os modelos do primeiro acesso (precisa do idioma da
  /// tela, por isso vem de fora).
  Future<void> load({List<Checklist> Function()? defaults}) async {
    _isLoading = true;
    notifyListeners();

    if (defaults != null) await _storage.ensureDefaults(defaults);
    _checklists = await _storage.getAll();
    _checklists.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    _isLoading = false;
    notifyListeners();
  }
}
