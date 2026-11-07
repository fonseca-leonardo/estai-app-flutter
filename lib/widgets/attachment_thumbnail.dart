import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Miniatura quadrada de um anexo: a foto (local ou remota) ou um ícone de
/// PDF com o nome do arquivo. Com [onRemove], mostra um "x" no canto.
class AttachmentThumbnail extends StatelessWidget {
  static const double size = 88;

  final String fileName;
  final bool isImage;
  final String? localPath;
  final String? url;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const AttachmentThumbnail({
    super.key,
    required this.fileName,
    required this.isImage,
    this.localPath,
    this.url,
    this.onTap,
    this.onRemove,
  });

  Widget _fallback() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isImage ? Icons.image_outlined : Icons.picture_as_pdf_outlined,
            color: Colors.white.withValues(alpha: 0.8),
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            fileName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    final path = localPath;
    final remote = url;
    if (isImage && path != null) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }
    if (isImage && remote != null) {
      return Image.network(
        remote,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(),
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
      );
    }
    return _fallback();
  }

  @override
  Widget build(BuildContext context) {
    final remove = onRemove;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: Material(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(onTap: onTap, child: _content()),
            ),
          ),
          if (remove != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: remove,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
