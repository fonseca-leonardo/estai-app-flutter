import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/logbook_entry_type.dart';
import '../../../widgets/selectable_pill.dart';
import 'logbook_entry_type_icon.dart';

/// Filtro por tipo em uma linha rolável; `null` é "Todos".
class LogbookTypeFilter extends StatelessWidget {
  final LogbookEntryType? selected;
  final ValueChanged<LogbookEntryType?> onChanged;

  const LogbookTypeFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 8,
        children: [
          SelectablePill(
            label: l10n.logbookFilterAll,
            selected: selected == null,
            onTap: () => onChanged(null),
          ),
          for (final type in LogbookEntryType.values)
            SelectablePill(
              icon: logbookEntryTypeIcon(type),
              label: type.label(l10n),
              selected: selected == type,
              onTap: () => onChanged(type),
            ),
        ],
      ),
    );
  }
}
