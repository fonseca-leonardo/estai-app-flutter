import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat_reminder.dart';
import '../../../widgets/ui/app_dialog.dart';

/// `true` se o usuário confirmou. Recorrente avisa que o próximo será
/// criado.
Future<bool> showMarkReminderDoneDialog(
  BuildContext context,
  BoatReminder reminder,
) {
  final l10n = AppLocalizations.of(context)!;
  final months = reminder.recurrenceMonths;
  return AppDialog.confirm(
    context,
    title: l10n.boatReminderMarkDone,
    message: months != null
        ? l10n.boatReminderMarkDoneRecurringConfirm(months)
        : l10n.boatReminderMarkDoneConfirm,
    confirmLabel: l10n.boatReminderMarkDone,
  );
}
