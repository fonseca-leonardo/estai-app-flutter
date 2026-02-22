import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../l10n/app_localizations.dart';

class PermissionStatusCard extends StatelessWidget {
  const PermissionStatusCard({super.key, required this.permission});

  final LocationPermission? permission;

  static const Color _green = Color(0xFF22C55E);
  static const Color _red = Color(0xFFEF4444);
  static const Color _amber = Color(0xFFEAB308);

  Color _statusColor() {
    switch (permission) {
      case LocationPermission.always:
        return _green;
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        return _red;
      default:
        return _amber;
    }
  }

  IconData _statusIcon() {
    switch (permission) {
      case LocationPermission.always:
        return Icons.check_circle_outline;
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        return Icons.cancel_outlined;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String statusText;
    final String subtitleText;
    switch (permission) {
      case LocationPermission.always:
        statusText = l10n.locationPermissionAlways;
        subtitleText = l10n.locationPermissionAlwaysSubtitle;
        break;
      case LocationPermission.whileInUse:
        statusText = l10n.locationPermissionWhileInUse;
        subtitleText = l10n.locationPermissionWhileInUseSubtitle;
        break;
      case LocationPermission.denied:
        statusText = l10n.locationPermissionDenied;
        subtitleText = l10n.locationPermissionDeniedSubtitle;
        break;
      case LocationPermission.deniedForever:
        statusText = l10n.locationPermissionDeniedForever;
        subtitleText = l10n.locationPermissionDeniedForeverSubtitle;
        break;
      default:
        statusText = l10n.locationPermissionChecking;
        subtitleText = l10n.locationPermissionCheckingSubtitle;
    }

    final statusColor = _statusColor();
    final statusIcon = _statusIcon();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border.all(color: statusColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitleText,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
