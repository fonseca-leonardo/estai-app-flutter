import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/engine_hours_format.dart';
import '../../../widgets/dark_input_decoration.dart';

/// Repetição da manutenção a cada X meses e/ou Y horas de motor.
class MaintenanceRecurrenceCard extends StatelessWidget {
  final bool enabled;
  final TextEditingController monthsController;
  final TextEditingController hoursController;
  final ValueChanged<bool> onEnabledChanged;

  /// Manutenção já realizada: a próxima conta a partir da realização, não de
  /// uma conclusão futura.
  final bool fromCompletion;

  const MaintenanceRecurrenceCard({
    super.key,
    required this.enabled,
    required this.monthsController,
    required this.hoursController,
    required this.onEnabledChanged,
    this.fromCompletion = false,
  });

  String? _validateMonths(AppLocalizations l10n, String? value) {
    final months = value?.trim() ?? '';
    final hours = hoursController.text.trim();
    if (months.isEmpty && hours.isEmpty) {
      return l10n.maintenanceRecurrenceRequired;
    }
    if (months.isEmpty) return null;
    final parsed = int.tryParse(months);
    return parsed == null || parsed <= 0 ? l10n.invalidNumber : null;
  }

  String? _validateHours(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = EngineHoursFormat.parse(value);
    return parsed == null || parsed <= 0 ? l10n.invalidNumber : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.repeat, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.maintenanceRecurrenceTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fromCompletion
                          ? l10n.maintenanceRecurrenceSubtitleCompleted
                          : l10n.maintenanceRecurrenceSubtitle,
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
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: monthsController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: darkInputDecoration(
                      l10n.maintenanceRecurrenceMonthsLabel,
                    ),
                    validator: (value) => _validateMonths(l10n, value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: hoursController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(color: Colors.white),
                    decoration: darkInputDecoration(
                      l10n.maintenanceRecurrenceHoursLabel,
                    ),
                    validator: (value) => _validateHours(l10n, value),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
