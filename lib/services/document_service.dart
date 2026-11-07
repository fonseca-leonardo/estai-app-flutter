import 'dart:convert';
import '../models/boat_document.dart';
import '../models/document_type.dart';
import '../models/reminder_settings.dart';
import 'estai_api_client.dart';

/// Campos editáveis de um documento, usados para criar e atualizar. Os
/// anexos vão à parte, pelo `AttachmentService`.
class DocumentInput {
  final DocumentType type;
  final String? title;
  final String? number;
  final String? issuer;
  final DateTime? issuedAt;
  final DateTime? expiresAt;
  final String? notes;
  final ReminderSettings reminder;

  DocumentInput({
    required this.type,
    this.title,
    this.number,
    this.issuer,
    this.issuedAt,
    this.expiresAt,
    this.notes,
    required this.reminder,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.apiValue,
      'title': title,
      'number': number,
      'issuer': issuer,
      'issuedAt': issuedAt?.toUtc().toIso8601String(),
      'expiresAt': expiresAt?.toUtc().toIso8601String(),
      'notes': notes,
      'reminder': reminder.toJson(),
    };
  }
}

String? _extractErrorMessage(String body) {
  try {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    final message = jsonData['message'];
    if (message is List) return message.join('\n');
    return message as String?;
  } catch (_) {
    return null;
  }
}

/// Consome os endpoints de documentos da API do Estai: do barco
/// (`/boats/{id}/documents`), pessoais (`/me/documents`) e de um documento
/// (`/documents/{id}`).
class DocumentService {
  final EstaiApiClient _apiClient;

  DocumentService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  Map<String, dynamic> _readData(String body) {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    final data = jsonData['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw ApiException('Invalid response: data field is null');
    }
    return data;
  }

  /// [boatId] nulo lista os documentos pessoais.
  Future<List<BoatDocument>> getDocuments({String? boatId}) async {
    try {
      final response = await _apiClient.get(_collectionPath(boatId));

      if (response.statusCode == 200) {
        final data = _readData(response.body);
        return (data['items'] as List<dynamic>)
            .map((item) => BoatDocument.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load documents: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading documents: $e');
    }
  }

  /// Traz o documento com as URLs dos anexos renovadas.
  Future<BoatDocument> getDocument(String id) async {
    try {
      final response = await _apiClient.get('/documents/$id');

      if (response.statusCode == 200) {
        return BoatDocument.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load document: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading document: $e');
    }
  }

  /// [boatId] nulo cria um documento pessoal.
  Future<BoatDocument> createDocument({
    String? boatId,
    required DocumentInput input,
  }) async {
    try {
      final response = await _apiClient.post(
        _collectionPath(boatId),
        body: input.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return BoatDocument.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to create document: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error creating document: $e');
    }
  }

  Future<BoatDocument> updateDocument({
    required String id,
    required DocumentInput input,
  }) async {
    try {
      final response = await _apiClient.put(
        '/documents/$id',
        body: input.toJson(),
      );

      if (response.statusCode == 200) {
        return BoatDocument.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to update document: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error updating document: $e');
    }
  }

  Future<void> deleteDocument(String id) async {
    try {
      final response = await _apiClient.delete('/documents/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to delete document: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error deleting document: $e');
    }
  }

  String _collectionPath(String? boatId) =>
      boatId == null ? '/me/documents' : '/boats/$boatId/documents';
}
