import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/engine_hours_format.dart';
import '../../../widgets/dark_input_decoration.dart';

/// Dados de uma manutenção já realizada: quando foi feita, horímetro, custo e
/// observações.
class MaintenanceCompletionCard extends StatelessWidget {
  final DateTime completedAt;
  final TextEditingController engineHoursController;
  final TextEditingController costController;
  final TextEditingController notesController;
  final VoidCallback onPickDate;

  const MaintenanceCompletionCard({
    super.key,
    required this.completedAt,
    required this.engineHoursController,
    required this.costController,
    required this.notesController,
    required this.onPickDate,
  });

  String? _validateOptionalNumber(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = EngineHoursFormat.parse(value);
    return parsed == null || parsed < 0 ? l10n.invalidNumber : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

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
          InkWell(
            onTap: onPickDate,
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: darkInputDecoration(l10n.completeMaintenanceDate),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormat.yMMMd(locale).format(completedAt),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: engineHoursController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: darkInputDecoration(
              l10n.completeMaintenanceEngineHours,
              suffixText: 'h',
            ),
            validator: (value) => _validateOptionalNumber(l10n, value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: costController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: darkInputDecoration(l10n.completeMaintenanceCost),
            validator: (value) => _validateOptionalNumber(l10n, value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: notesController,
            maxLines: 3,
            maxLength: 1000,
            style: const TextStyle(color: Colors.white),
            decoration: darkInputDecoration(l10n.notesOptional),
          ),
        ],
      ),
    );
  }
}
