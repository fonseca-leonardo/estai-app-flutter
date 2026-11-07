import 'package:flutter/material.dart';
import '../../../models/document_attachment.dart';
import '../../../widgets/attachment_thumbnail.dart';

/// Miniaturas dos anexos; tocar abre a foto ou o PDF.
class DocumentAttachmentsGallery extends StatelessWidget {
  final List<DocumentAttachment> attachments;
  final ValueChanged<DocumentAttachment> onOpen;

  const DocumentAttachmentsGallery({
    super.key,
    required this.attachments,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final attachment in attachments)
          AttachmentThumbnail(
            fileName: attachment.fileName,
            isImage: attachment.isImage,
            url: attachment.url,
            onTap: () => onOpen(attachment),
          ),
      ],
    );
  }
}
