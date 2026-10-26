import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/ramp_schedule.dart';
import '../../../utils/marina_time.dart';

/// Resultado do diálogo: `null` se o usuário desistiu; senão, se também quer
/// cancelar a subida de volta.
Future<bool?> showCancelRampScheduleDialog({
  required BuildContext context,
  RampSchedule? linkedReturn,
}) {
  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).toString();
  var alsoCancelReturn = linkedReturn != null;

  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: const Color(0xFF0A0A0A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        title: Text(
          l10n.cancelRampSchedule,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.cancelRampScheduleConfirm,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
            if (linkedReturn != null) ...[
              const SizedBox(height: 12),
              CheckboxListTile(
                value: alsoCancelReturn,
                onChanged: (value) =>
                    setState(() => alsoCancelReturn = value ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.white,
                checkColor: Colors.black,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                title: Text(
                  l10n.cancelRampScheduleAlsoReturn(
                    '${MarinaTime.formatDate(linkedReturn.scheduledAt, locale)} '
                    '${MarinaTime.formatTime(linkedReturn.scheduledAt)}',
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.keepRampSchedule,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(alsoCancelReturn),
            child: Text(
              l10n.cancelRampSchedule,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    ),
  );
}
