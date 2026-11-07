import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/attachment_picker_service.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/ui/app_sheet.dart';
import '../../../widgets/ui/app_tile.dart';

/// Pergunta de onde vem o anexo: câmera, galeria ou PDF. `null` se o
/// usuário fechou.
Future<AttachmentSource?> showAttachmentSourceSheet(BuildContext context) {
  return AppSheet.show<AttachmentSource>(
    context,
    builder: (_) => const AttachmentSourceSheet(),
  );
}

class AttachmentSourceSheet extends StatelessWidget {
  const AttachmentSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.attachmentAddTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTile(
          icon: Icons.photo_camera_outlined,
          title: l10n.attachmentSourceCamera,
          onTap: () => navigator.pop(AttachmentSource.camera),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTile(
          icon: Icons.photo_library_outlined,
          title: l10n.attachmentSourceGallery,
          onTap: () => navigator.pop(AttachmentSource.gallery),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTile(
          icon: Icons.picture_as_pdf_outlined,
          title: l10n.attachmentSourcePdf,
          onTap: () => navigator.pop(AttachmentSource.pdf),
        ),
      ],
    );
  }
}
