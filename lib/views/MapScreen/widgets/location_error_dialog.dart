import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../l10n/app_localizations.dart';

class LocationErrorDialog {
  static Future<void> show(BuildContext context, {required String errorKey}) {
    final l10n = AppLocalizations.of(context)!;

    String errorText;
    if (errorKey.contains(':')) {
      final parts = errorKey.split(':');
      final key = parts[0];
      final param = parts.length > 1 ? parts[1] : '';
      switch (key) {
        case 'errorGettingLocation':
          errorText = l10n.errorGettingLocation(param);
          break;
        case 'errorUpdatingLocation':
          errorText = l10n.errorUpdatingLocation(param);
          break;
        default:
          errorText = errorKey;
      }
    } else {
      switch (errorKey) {
        case 'locationServicesDisabled':
          errorText = l10n.locationServicesDisabled;
          break;
        case 'locationPermissionDenied':
          errorText = l10n.locationPermissionDenied;
          break;
        case 'locationPermissionDeniedForever':
          errorText = l10n.locationPermissionDeniedForever;
          break;
        default:
          errorText = errorKey;
      }
    }

    final isDeniedForever = errorKey == 'locationPermissionDeniedForever';

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black.withValues(alpha: 0.9),
          icon: Icon(
            Icons.location_off_rounded,
            size: 48,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                errorText,
                style: const TextStyle(color: Colors.white, height: 1.4),
              ),
              if (isDeniedForever) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      openAppSettings();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    child: Text(l10n.openAppSettings),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  l10n.cancel,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
