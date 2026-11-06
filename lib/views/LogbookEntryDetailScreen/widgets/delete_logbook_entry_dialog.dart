import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/ui/app_dialog.dart';

/// `true` se o usuário confirmou a exclusão.
Future<bool> showDeleteLogbookEntryDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return AppDialog.confirm(
    context,
    title: l10n.deleteLogbookEntry,
    message: l10n.deleteLogbookEntryConfirm,
    confirmLabel: l10n.deleteLogbookEntry,
    destructive: true,
  );
}
