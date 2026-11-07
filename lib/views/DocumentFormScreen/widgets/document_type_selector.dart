import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/document_type.dart';
import '../../../widgets/selectable_pill.dart';

/// Tipos do escopo (barco ou pessoal) em pílulas.
class DocumentTypeSelector extends StatelessWidget {
  final List<DocumentType> types;
  final DocumentType selected;
  final ValueChanged<DocumentType> onChanged;

  const DocumentTypeSelector({
    super.key,
    required this.types,
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
        for (final type in types)
          SelectablePill(
            icon: type.icon,
            label: type.label(l10n),
            selected: type == selected,
            onTap: () => onChanged(type),
          ),
      ],
    );
  }
}
