import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/ui/app_dialog.dart';

Future<void> showCancelOrderDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await AppDialog.confirm(
    context,
    title: l10n.cancelServiceOrder,
    message: l10n.cancelServiceOrderConfirm,
    confirmLabel: l10n.cancelServiceOrder,
    cancelLabel: l10n.keepOrder,
    destructive: true,
  );
  if (confirmed) onConfirm();
}
