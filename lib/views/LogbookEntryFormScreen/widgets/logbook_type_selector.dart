import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/logbook_entry_type.dart';
import '../../../widgets/selectable_pill.dart';
import '../../LogbookScreen/widgets/logbook_entry_type_icon.dart';

/// Tipos que o usuário pode registrar à mão (viagem vem da navegação).
class LogbookTypeSelector extends StatelessWidget {
  final LogbookEntryType selected;
  final ValueChanged<LogbookEntryType> onChanged;

  const LogbookTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final type in LogbookEntryType.manualTypes)
          SelectablePill(
            icon: logbookEntryTypeIcon(type),
            label: type.label(l10n),
            selected: type == selected,
            onTap: () => onChanged(type),
          ),
      ],
    );
  }
}
