import 'package:flutter/foundation.dart';
import '../models/logbook_entry.dart';
import '../models/logbook_entry_type.dart';
import '../services/logbook_service.dart';

/// Diário de bordo de uma embarcação: lista paginada com filtro por tipo.
///
/// Criada pela própria tela com o [boatId] (escopo de tela).
class LogbookViewModel extends ChangeNotifier {
  LogbookViewModel({required this.boatId, LogbookService? logbookService})
    : _logbookService = logbookService ?? LogbookService();

  final String boatId;
  final LogbookService _logbookService;

  List<LogbookEntry> _entries = [];
  LogbookEntryType? _filter;
  int _page = 0;
  bool _hasMore = false;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  List<LogbookEntry> get entries => List.unmodifiable(_entries);
  LogbookEntryType? get filter => _filter;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _logbookService.getEntries(
        boatId: boatId,
        type: _filter,
      );
      _entries = result.items;
      _page = result.page;
      _hasMore = result.hasMore;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore || _isLoading) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _logbookService.getEntries(
        boatId: boatId,
        type: _filter,
        page: _page + 1,
      );
      _entries = [..._entries, ...result.items];
      _page = result.page;
      _hasMore = result.hasMore;
    } catch (e) {
      // Mantém o que já foi carregado; o usuário pode tentar de novo
      // rolando até o fim.
    }
    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> setFilter(LogbookEntryType? type) async {
    if (type == _filter) return;
    _filter = type;
    _entries = [];
    await load();
  }

  /// Atualiza a entrada editada sem recarregar a lista.
  void replace(LogbookEntry entry) {
    final index = _entries.indexWhere((item) => item.id == entry.id);
    if (index == -1) return;
    _entries[index] = entry;
    notifyListeners();
  }

  Future<bool> delete(String id) async {
    final index = _entries.indexWhere((item) => item.id == id);
    if (index == -1) return false;
    final removed = _entries.removeAt(index);
    notifyListeners();

    try {
      await _logbookService.deleteEntry(id);
      return true;
    } catch (e) {
      _entries.insert(index, removed);
      notifyListeners();
      return false;
    }
  }
}
