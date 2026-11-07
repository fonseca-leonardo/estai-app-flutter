import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat_document.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/ui/app_card.dart';
import '../../../widgets/ui/icon_chip.dart';
import 'document_expiry_label.dart';
import 'document_status_chip.dart';

class DocumentCard extends StatelessWidget {
  final BoatDocument document;
  final VoidCallback? onTap;

  const DocumentCard({super.key, required this.document, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = document.displayTitle(l10n);
    final typeLabel = document.type.label(l10n);
    final number = document.number?.trim();
    final subtitle = [
      if (title != typeLabel) typeLabel,
      if (number != null && number.isNotEmpty) number,
    ].join(' · ');
    final attachmentsCount = document.attachments.length;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconChip(icon: document.type.icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    DocumentExpiryLabel(document: document),
                    if (attachmentsCount > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_file,
                            size: 15,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '$attachmentsCount',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          DocumentStatusChip(status: document.status()),
        ],
      ),
    );
  }
}
