import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/document_attachment.dart';
import '../../../models/pending_attachment.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/attachment_thumbnail.dart';
import '../../../widgets/ui/app_card.dart';

/// Anexos do documento no formulário: os já enviados, os escolhidos que
/// ainda vão subir e o botão de adicionar.
class DocumentAttachmentsField extends StatelessWidget {
  final List<DocumentAttachment> attachments;
  final List<PendingAttachment> pendingFiles;
  final bool canAdd;
  final VoidCallback onAdd;
  final ValueChanged<DocumentAttachment> onRemoveAttachment;
  final ValueChanged<PendingAttachment> onRemovePending;

  const DocumentAttachmentsField({
    super.key,
    required this.attachments,
    required this.pendingFiles,
    required this.canAdd,
    required this.onAdd,
    required this.onRemoveAttachment,
    required this.onRemovePending,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.attachmentsHint(
              PendingAttachment.maxPerOwner,
              PendingAttachment.maxSizeBytes ~/ (1024 * 1024),
            ),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final attachment in attachments)
                AttachmentThumbnail(
                  fileName: attachment.fileName,
                  isImage: attachment.isImage,
                  url: attachment.url,
                  onRemove: () => onRemoveAttachment(attachment),
                ),
              for (final file in pendingFiles)
                AttachmentThumbnail(
                  fileName: file.fileName,
                  isImage: !file.isPdf,
                  localPath: file.path,
                  onRemove: () => onRemovePending(file),
                ),
              if (canAdd)
                SizedBox(
                  width: AttachmentThumbnail.size,
                  height: AttachmentThumbnail.size,
                  child: OutlinedButton(
                    onPressed: onAdd,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo_outlined, size: 24),
                        const SizedBox(height: 6),
                        Text(
                          l10n.attachmentAdd,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
