import 'package:path/path.dart' as p;

/// Arquivo escolhido no aparelho (câmera, galeria ou PDF) que ainda não foi
/// enviado.
class PendingAttachment {
  /// Tipos aceitos pelo backend.
  static const List<String> allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'heic',
    'pdf',
  ];
  static const int maxSizeBytes = 10 * 1024 * 1024;
  static const int maxPerOwner = 5;

  final String path;
  final String fileName;
  final int sizeBytes;

  PendingAttachment({
    required this.path,
    required this.sizeBytes,
    String? fileName,
  }) : fileName = fileName ?? p.basename(path);

  String get extension =>
      p.extension(fileName).replaceFirst('.', '').toLowerCase();

  bool get isAllowedType => allowedExtensions.contains(extension);
  bool get isTooLarge => sizeBytes > maxSizeBytes;
  bool get isPdf => extension == 'pdf';

  String get contentType {
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'heic':
        return 'image/heic';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'image/jpeg';
    }
  }
}
