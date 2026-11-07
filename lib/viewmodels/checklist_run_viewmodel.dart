import 'package:flutter/foundation.dart';
import '../models/checklist.dart';

/// Execução de um ou mais checklists. O que foi marcado vive só em
/// memória: fechar a tela zera.
class ChecklistRunViewModel extends ChangeNotifier {
  ChecklistRunViewModel({required List<Checklist> checklists})
    : checklists = List.unmodifiable(checklists);

  final List<Checklist> checklists;
  final Set<String> _checked = {};

  int get totalCount =>
      checklists.fold(0, (total, checklist) => total + checklist.items.length);
  int get checkedCount => _checked.length;
  int get uncheckedCount => totalCount - checkedCount;
  bool get isComplete => totalCount > 0 && uncheckedCount == 0;
  double get progress => totalCount == 0 ? 0 : checkedCount / totalCount;

  bool isChecked(String itemId) => _checked.contains(itemId);

  void toggle(String itemId) {
    if (!_checked.remove(itemId)) _checked.add(itemId);
    notifyListeners();
  }

  void reset() {
    if (_checked.isEmpty) return;
    _checked.clear();
    notifyListeners();
  }
}
