import 'package:flutter/foundation.dart';
import '../models/checklist.dart';
import '../models/checklist_trigger.dart';
import '../services/checklist_storage_service.dart';

enum ChecklistFormError { missingName, noItems, unknown }

/// Cria ou edita um checklist. Os itens ganham id na hora em que são
/// adicionados, para a lista poder ser reordenada.
///
/// Criada pela própria tela (escopo de tela).
class ChecklistFormViewModel extends ChangeNotifier {
  ChecklistFormViewModel({
    this.initial,
    ChecklistStorageService? storage,
    String Function()? idGenerator,
  }) : _storage = storage ?? ChecklistStorageService(),
       _generateId = idGenerator ?? Checklist.generateId,
       _trigger = initial?.trigger ?? ChecklistTrigger.beforeNavigation,
       _items = List.of(initial?.items ?? const []) {
    if (_items.isEmpty) addItem(notify: false);
    _lastAddedId = null;
  }

  final Checklist? initial;
  final ChecklistStorageService _storage;
  final String Function() _generateId;

  ChecklistTrigger _trigger;
  final List<ChecklistItem> _items;
  String? _lastAddedId;
  bool _isSaving = false;
  ChecklistFormError? _error;

  bool get isEditing => initial != null;
  ChecklistTrigger get trigger => _trigger;
  List<ChecklistItem> get items => List.unmodifiable(_items);
  bool get canAddItem => _items.length < Checklist.maxItems;
  bool get isSaving => _isSaving;
  ChecklistFormError? get error => _error;

  /// Item recém-adicionado, para a tela focar o campo dele.
  String? get lastAddedId => _lastAddedId;

  void setTrigger(ChecklistTrigger value) {
    if (_trigger == value) return;
    _trigger = value;
    notifyListeners();
  }

  void addItem({bool notify = true}) {
    if (!canAddItem) return;
    final item = ChecklistItem(id: _generateId(), text: '');
    _items.add(item);
    _lastAddedId = item.id;
    if (_error == ChecklistFormError.noItems) _error = null;
    if (notify) notifyListeners();
  }

  /// Chamado a cada tecla: não notifica, o campo já mostra o texto.
  void updateItem(String id, String text) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _items[index] = _items[index].copyWith(text: text);
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    if (_lastAddedId == id) _lastAddedId = null;
    notifyListeners();
  }

  /// Move o item de [oldIndex] para a posição final [newIndex], como no
  /// `ReorderableListView.onReorderItem`.
  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= _items.length) return;
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex.clamp(0, _items.length), item);
    _lastAddedId = null;
    notifyListeners();
  }

  /// Itens em branco são descartados.
  Future<bool> save({required String name, DateTime? now}) async {
    final trimmedName = name.trim();
    final items = [
      for (final item in _items)
        if (item.text.trim().isNotEmpty) item.copyWith(text: item.text.trim()),
    ];

    if (trimmedName.isEmpty) {
      _error = ChecklistFormError.missingName;
    } else if (items.isEmpty) {
      _error = ChecklistFormError.noItems;
    } else {
      _error = null;
    }
    if (_error != null) {
      notifyListeners();
      return false;
    }

    _isSaving = true;
    notifyListeners();

    final timestamp = now ?? DateTime.now();
    final current = initial;
    final checklist = current == null
        ? Checklist(
            id: _generateId(),
            name: trimmedName,
            trigger: _trigger,
            items: items,
            createdAt: timestamp,
            updatedAt: timestamp,
          )
        : current.copyWith(
            name: trimmedName,
            trigger: _trigger,
            items: items,
            updatedAt: timestamp,
          );

    try {
      await _storage.save(checklist);
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isSaving = false;
      _error = ChecklistFormError.unknown;
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete() async {
    final current = initial;
    if (current == null) return false;
    try {
      await _storage.delete(current.id);
      return true;
    } catch (_) {
      _error = ChecklistFormError.unknown;
      notifyListeners();
      return false;
    }
  }
}
