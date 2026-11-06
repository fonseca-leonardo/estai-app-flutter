import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/ui/app_dialog.dart';

/// `true` se o usuário confirmou a exclusão.
Future<bool> showDeleteMaintenanceDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return AppDialog.confirm(
    context,
    title: l10n.deleteMaintenance,
    message: l10n.deleteMaintenanceConfirm,
    confirmLabel: l10n.deleteMaintenance,
    destructive: true,
  );
}
