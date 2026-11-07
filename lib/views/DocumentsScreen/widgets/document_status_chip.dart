import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/document_status.dart';
import '../../../theme/app_colors.dart';

Color documentStatusColor(DocumentStatus status) {
  switch (status) {
    case DocumentStatus.expired:
      return AppColors.danger;
    case DocumentStatus.expiringSoon:
      return AppColors.warning;
    case DocumentStatus.valid:
      return AppColors.success;
    case DocumentStatus.noExpiry:
      return Colors.white.withValues(alpha: 0.6);
  }
}

class DocumentStatusChip extends StatelessWidget {
  final DocumentStatus status;

  const DocumentStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = documentStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.label(l10n),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
