/// Arquivo anexado (foto ou PDF). A [url] é assinada e temporária: pode vir
/// ausente na listagem e é renovada ao buscar o item.
class DocumentAttachment {
  final String id;
  final String fileName;
  final String contentType;
  final int sizeBytes;
  final String? url;
  final DateTime createdAt;

  DocumentAttachment({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    this.url,
    required this.createdAt,
  });

  bool get isImage => contentType.startsWith('image/');
  bool get isPdf => contentType == 'application/pdf';

  factory DocumentAttachment.fromJson(Map<String, dynamic> json) {
    return DocumentAttachment(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      contentType: json['contentType'] as String,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      url: json['url'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
