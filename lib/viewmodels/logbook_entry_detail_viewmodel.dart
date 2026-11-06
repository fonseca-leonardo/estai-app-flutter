import 'package:flutter/foundation.dart';
import '../models/logbook_entry.dart';
import '../services/logbook_service.dart';

/// Detalhe de uma entrada do diário de bordo: mostra, recebe a versão
/// editada e exclui.
class LogbookEntryDetailViewModel extends ChangeNotifier {
  LogbookEntryDetailViewModel({
    required LogbookEntry entry,
    LogbookService? logbookService,
  }) : _entry = entry,
       _logbookService = logbookService ?? LogbookService();

  final LogbookService _logbookService;

  LogbookEntry _entry;
  bool _isDeleting = false;
  bool _changed = false;

  LogbookEntry get entry => _entry;
  bool get isDeleting => _isDeleting;

  /// Se a entrada foi editada ou excluída; a lista recarrega ao voltar.
  bool get changed => _changed;

  void update(LogbookEntry entry) {
    _entry = entry;
    _changed = true;
    notifyListeners();
  }

  Future<bool> delete() async {
    _isDeleting = true;
    notifyListeners();

    try {
      await _logbookService.deleteEntry(_entry.id);
      _changed = true;
      return true;
    } catch (e) {
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }
}
