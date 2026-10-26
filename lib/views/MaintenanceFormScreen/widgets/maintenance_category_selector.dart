import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/maintenance_category.dart';
import '../../../widgets/selectable_pill.dart';
import '../../MaintenancesScreen/widgets/maintenance_category_icon.dart';

class MaintenanceCategorySelector extends StatelessWidget {
  final MaintenanceCategory selected;
  final ValueChanged<MaintenanceCategory> onChanged;

  const MaintenanceCategorySelector({
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
        for (final category in MaintenanceCategory.values)
          SelectablePill(
            icon: maintenanceCategoryIcon(category),
            label: category.label(l10n),
            selected: category == selected,
            onTap: () => onChanged(category),
          ),
      ],
    );
  }
}
