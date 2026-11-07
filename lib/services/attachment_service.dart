import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/document_attachment.dart';
import '../models/pending_attachment.dart';
import 'estai_api_client.dart';

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

/// Anexos (foto/PDF) de um item do Diário da Embarcação. [ownerPath] é o
/// recurso dono do anexo, por exemplo `/documents/{id}`; o mesmo contrato
/// serve depois para manutenções e despesas.
class AttachmentService {
  final EstaiApiClient _apiClient;

  AttachmentService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  static String documentPath(String documentId) => '/documents/$documentId';

  /// `POST {ownerPath}/attachments` com o arquivo no campo `file`.
  Future<DocumentAttachment> upload({
    required String ownerPath,
    required PendingAttachment file,
  }) async {
    try {
      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: file.fileName,
        contentType: MediaType.parse(file.contentType),
      );
      final response = await _apiClient.multipart(
        '$ownerPath/attachments',
        files: [multipartFile],
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;
        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }
        return DocumentAttachment.fromJson(data);
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to upload attachment: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error uploading attachment: $e');
    }
  }

  Future<void> delete({
    required String ownerPath,
    required String attachmentId,
  }) async {
    try {
      final response = await _apiClient.delete(
        '$ownerPath/attachments/$attachmentId',
      );

      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 404) {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to delete attachment: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error deleting attachment: $e');
    }
  }
}
