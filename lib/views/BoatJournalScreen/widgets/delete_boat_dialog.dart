import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/ui/app_dialog.dart';

/// `true` se o usuário confirmou a exclusão.
Future<bool> showDeleteBoatDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return AppDialog.confirm(
    context,
    title: l10n.deleteBoat,
    message: l10n.confirmDeleteBoat,
    confirmLabel: l10n.deleteBoat,
    destructive: true,
  );
}
