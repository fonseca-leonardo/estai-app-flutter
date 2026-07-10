import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class MarinaAccessToggle extends StatelessWidget {
  final bool value;
  final bool isUpdating;
  final ValueChanged<bool> onChanged;

  const MarinaAccessToggle({
    super.key,
    required this.value,
    required this.isUpdating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.marinaAccessToggleLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.marinaAccessToggleDescription,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          isUpdating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Switch(
                  value: value,
                  onChanged: onChanged,
                  activeTrackColor: Colors.white.withValues(alpha: 0.9),
                  activeThumbColor: Colors.black,
                ),
        ],
      ),
    );
  }
}
