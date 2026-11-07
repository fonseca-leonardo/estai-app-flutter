import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/checklist_trigger.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/selectable_pill.dart';

/// Quando o checklist aparece, com a explicação da opção escolhida.
class ChecklistTriggerSelector extends StatelessWidget {
  final ChecklistTrigger selected;
  final ValueChanged<ChecklistTrigger> onChanged;

  const ChecklistTriggerSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final trigger in ChecklistTrigger.values)
              SelectablePill(
                icon: trigger.icon,
                label: trigger.label(l10n),
                selected: trigger == selected,
                onTap: () => onChanged(trigger),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          selected.description(l10n),
          style: TextStyle(color: AppColors.textTertiary, fontSize: 13),
        ),
      ],
    );
  }
}
