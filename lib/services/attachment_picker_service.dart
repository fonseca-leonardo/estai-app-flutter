import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pending_attachment.dart';

/// De onde vem o anexo escolhido pelo usuário.
enum AttachmentSource { camera, gallery, pdf }

/// Abre a câmera, a galeria ou o seletor de arquivos e devolve os arquivos
/// escolhidos, ainda não enviados. Fotos saem comprimidas para caber no
/// limite de upload.
class AttachmentPickerService {
  static const int _imageQuality = 80;
  static const double _maxImageDimension = 2048;

  final ImagePicker _imagePicker;

  AttachmentPickerService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  /// Lista vazia se o usuário cancelou.
  Future<List<PendingAttachment>> pick(AttachmentSource source) async {
    switch (source) {
      case AttachmentSource.camera:
        final photo = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: _imageQuality,
          maxWidth: _maxImageDimension,
          maxHeight: _maxImageDimension,
        );
        return photo == null ? const [] : [await _fromXFile(photo)];
      case AttachmentSource.gallery:
        final images = await _imagePicker.pickMultiImage(
          imageQuality: _imageQuality,
          maxWidth: _maxImageDimension,
          maxHeight: _maxImageDimension,
        );
        return Future.wait(images.map(_fromXFile));
      case AttachmentSource.pdf:
        final file = await FilePicker.pickFile(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        final path = file?.path;
        if (file == null || path == null) return const [];
        return [
          PendingAttachment(
            path: path,
            fileName: file.name,
            sizeBytes: file.size,
          ),
        ];
    }
  }

  Future<PendingAttachment> _fromXFile(XFile file) async {
    return PendingAttachment(
      path: file.path,
      fileName: file.name,
      sizeBytes: await file.length(),
    );
  }
}
