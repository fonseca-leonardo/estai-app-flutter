import 'package:flutter/foundation.dart';
import '../models/boat_document.dart';
import '../models/document_status.dart';
import '../services/document_service.dart';

/// Documentos do barco ([boatId]) ou, sem barco, os pessoais do usuário.
///
/// Criada pela própria tela (escopo de tela).
class DocumentsViewModel extends ChangeNotifier {
  DocumentsViewModel({this.boatId, DocumentService? documentService})
    : _documentService = documentService ?? DocumentService();

  final String? boatId;
  final DocumentService _documentService;

  List<BoatDocument> _documents = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool get isPersonal => boatId == null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<BoatDocument> get documents => List.unmodifiable(_documents);

  /// Vencidos e vencendo, do mais urgente para o menos.
  List<BoatDocument> get needingAttention =>
      _documents.where((doc) => doc.status().needsAttention).toList();

  /// Válidos (vencimento mais próximo primeiro) e, por último, sem validade.
  List<BoatDocument> get others =>
      _documents.where((doc) => !doc.status().needsAttention).toList();

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final items = await _documentService.getDocuments(boatId: boatId);
      _documents = sortByUrgency(items);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> delete(String id) async {
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index == -1) return false;
    final removed = _documents.removeAt(index);
    notifyListeners();

    try {
      await _documentService.deleteDocument(id);
      return true;
    } catch (e) {
      _documents.insert(index, removed);
      notifyListeners();
      return false;
    }
  }

  /// Vencidos, vencendo, válidos e sem validade; dentro de cada grupo, pelo
  /// vencimento mais próximo.
  @visibleForTesting
  static List<BoatDocument> sortByUrgency(
    List<BoatDocument> documents, {
    DateTime? now,
  }) {
    int rank(BoatDocument doc) =>
        DocumentStatus.values.indexOf(doc.status(now: now));
    return [...documents]..sort((a, b) {
      final byStatus = rank(a).compareTo(rank(b));
      if (byStatus != 0) return byStatus;
      final aExpires = a.expiresAt;
      final bExpires = b.expiresAt;
      if (aExpires == null || bExpires == null) return 0;
      return aExpires.compareTo(bExpires);
    });
  }
}
