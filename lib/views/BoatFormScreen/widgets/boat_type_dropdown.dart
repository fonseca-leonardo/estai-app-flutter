import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat_type.dart';

class BoatTypeDropdown extends StatelessWidget {
  final BoatType value;
  final InputDecoration decoration;
  final ValueChanged<BoatType> onChanged;

  const BoatTypeDropdown({
    super.key,
    required this.value,
    required this.decoration,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DropdownButtonFormField<BoatType>(
      initialValue: value,
      decoration: decoration,
      dropdownColor: Colors.black,
      style: const TextStyle(color: Colors.white),
      items: BoatType.values
          .map(
            (type) => DropdownMenuItem(
              value: type,
              child: Text(type.label(l10n)),
            ),
          )
          .toList(),
      onChanged: (type) {
        if (type != null) onChanged(type);
      },
    );
  }
}
