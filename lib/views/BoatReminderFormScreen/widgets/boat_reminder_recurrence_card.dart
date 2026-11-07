import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/dark_input_decoration.dart';
import '../../../widgets/ui/app_card.dart';
import '../../../widgets/ui/icon_chip.dart';

/// Repetição do lembrete a cada N meses.
class BoatReminderRecurrenceCard extends StatelessWidget {
  final bool enabled;
  final TextEditingController monthsController;
  final ValueChanged<bool> onEnabledChanged;

  const BoatReminderRecurrenceCard({
    super.key,
    required this.enabled,
    required this.monthsController,
    required this.onEnabledChanged,
  });

  String? _validateMonths(AppLocalizations l10n, String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    return parsed == null || parsed <= 0 ? l10n.invalidNumber : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const IconChip(icon: Icons.repeat),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.boatReminderRecurrenceTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.boatReminderRecurrenceSubtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: enabled,
                onChanged: onEnabledChanged,
                activeThumbColor: Colors.black,
                activeTrackColor: Colors.white,
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: monthsController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: darkInputDecoration(
                l10n.boatReminderRecurrenceMonthsLabel,
              ),
              validator: (value) => _validateMonths(l10n, value),
            ),
          ],
        ],
      ),
    );
  }
}
