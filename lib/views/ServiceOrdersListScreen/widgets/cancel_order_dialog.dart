import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

Future<void> showCancelOrderDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  final l10n = AppLocalizations.of(context)!;

  return showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color(0xFF0A0A0A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      title: Text(
        l10n.cancelServiceOrder,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        l10n.cancelServiceOrderConfirm,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(
            l10n.keepOrder,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            onConfirm();
          },
          child: Text(
            l10n.cancelServiceOrder,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ),
  );
}
