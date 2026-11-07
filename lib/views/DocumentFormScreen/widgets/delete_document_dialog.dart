import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/ui/app_dialog.dart';

/// `true` se o usuário confirmou a exclusão.
Future<bool> showDeleteDocumentDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return AppDialog.confirm(
    context,
    title: l10n.deleteDocument,
    message: l10n.deleteDocumentConfirm,
    confirmLabel: l10n.deleteDocument,
    destructive: true,
  );
}
