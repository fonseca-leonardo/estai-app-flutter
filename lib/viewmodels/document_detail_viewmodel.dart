import 'package:flutter/foundation.dart';
import '../models/boat_document.dart';
import '../services/document_service.dart';

/// Detalhe de um documento. Busca o documento ao abrir para renovar as URLs
/// dos anexos, que são temporárias.
///
/// Criada pela própria tela, com o documento já carregado ou só com o id
/// (vindo de um push).
class DocumentDetailViewModel extends ChangeNotifier {
  DocumentDetailViewModel({
    required this.documentId,
    BoatDocument? initial,
    DocumentService? documentService,
  }) : _document = initial,
       _documentService = documentService ?? DocumentService();

  final String documentId;
  final DocumentService _documentService;

  BoatDocument? _document;
  bool _isLoading = false;
  bool _isDeleting = false;
  bool _changed = false;
  String? _errorMessage;

  BoatDocument? get document => _document;
  bool get isLoading => _isLoading;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  /// Editado ou excluído aqui: quem abriu a tela recarrega a lista.
  bool get changed => _changed;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _document = await _documentService.getDocument(documentId);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Depois de editar: recarrega e marca a lista para atualizar.
  Future<void> onEdited() async {
    _changed = true;
    await load();
  }

  Future<bool> delete() async {
    _isDeleting = true;
    notifyListeners();

    try {
      await _documentService.deleteDocument(documentId);
      _changed = true;
      _isDeleting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isDeleting = false;
      notifyListeners();
      return false;
    }
  }
}
