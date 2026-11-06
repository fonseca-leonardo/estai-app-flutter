import '../../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/engine_hours_format.dart';
import '../../../widgets/dark_input_decoration.dart';

/// Vencimento por data e/ou horímetro.
class MaintenanceDueCard extends StatelessWidget {
  final DateTime? dueDate;
  final TextEditingController dueHoursController;
  final double? currentEngineHours;
  final bool showMissingDueError;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final ValueChanged<String> onDueHoursChanged;

  const MaintenanceDueCard({
    super.key,
    required this.dueDate,
    required this.dueHoursController,
    required this.currentEngineHours,
    required this.showMissingDueError,
    required this.onPickDate,
    required this.onClearDate,
    required this.onDueHoursChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final date = dueDate;
    final current = currentEngineHours;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showMissingDueError
              ? AppColors.danger.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.maintenanceDueHint,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onPickDate,
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: darkInputDecoration(l10n.maintenanceDueDateLabel),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      date != null
                          ? DateFormat.yMMMd(locale).format(date)
                          : l10n.maintenanceDueDateNone,
                      style: TextStyle(
                        color: date != null
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  if (date != null)
                    GestureDetector(
                      onTap: onClearDate,
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    )
                  else
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
            controller: dueHoursController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            onChanged: onDueHoursChanged,
            decoration: darkInputDecoration(
              l10n.maintenanceDueEngineHoursLabel,
              hint: current != null
                  ? l10n.engineHoursValue(
                      EngineHoursFormat.format(current, locale),
                    )
                  : null,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              final parsed = EngineHoursFormat.parse(value);
              return parsed == null || parsed < 0 ? l10n.invalidNumber : null;
            },
          ),
          if (showMissingDueError) ...[
            const SizedBox(height: 12),
            Text(
              l10n.maintenanceMissingDue,
              style: const TextStyle(color: AppColors.danger, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
