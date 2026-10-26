import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// `true` se o usuário confirmou a exclusão.
Future<bool> showDeleteMaintenanceDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color(0xFF0A0A0A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      title: Text(
        l10n.deleteMaintenance,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        l10n.deleteMaintenanceConfirm,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            l10n.deleteMaintenance,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
