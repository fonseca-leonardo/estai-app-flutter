import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class BackgroundLocationDisclosureDialog {
  static Future<bool> show(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black.withValues(alpha: 0.9),
          icon: Icon(
            Icons.location_on_rounded,
            size: 24,
            color: Colors.blue.withValues(alpha: 0.9),
          ),
          title: Text(
            l10n.backgroundLocationDisclosureTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.backgroundLocationDisclosureBody,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => {Navigator.of(dialogContext).pop(true)},
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.backgroundLocationAllow),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(
                  l10n.backgroundLocationNotNow,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                ),
              ),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }
}
