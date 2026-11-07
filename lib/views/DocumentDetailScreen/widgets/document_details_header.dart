import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat_document.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/ui/app_card.dart';
import '../../../widgets/ui/icon_chip.dart';
import '../../DocumentsScreen/widgets/document_expiry_label.dart';
import '../../DocumentsScreen/widgets/document_status_chip.dart';

/// Tipo, título, status e validade do documento.
class DocumentDetailsHeader extends StatelessWidget {
  final BoatDocument document;

  const DocumentDetailsHeader({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = document.displayTitle(l10n);
    final typeLabel = document.type.label(l10n);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconChip(icon: document.type.icon, size: 52, iconSize: 26),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (title != typeLabel) ...[
                  const SizedBox(height: 4),
                  Text(
                    typeLabel,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    DocumentStatusChip(status: document.status()),
                    DocumentExpiryLabel(document: document),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
