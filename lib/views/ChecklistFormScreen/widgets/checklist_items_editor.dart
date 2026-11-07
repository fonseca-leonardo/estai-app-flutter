import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/checklist.dart';
import 'checklist_item_field.dart';

/// Lista de itens reordenável, com "Adicionar item" no fim.
class ChecklistItemsEditor extends StatelessWidget {
  final List<ChecklistItem> items;
  final String? focusedItemId;
  final bool canAdd;
  final VoidCallback onAdd;
  final void Function(String id, String text) onChanged;
  final ValueChanged<String> onRemove;

  /// Índice final já ajustado (`onReorderItem`).
  final void Function(int oldIndex, int newIndex) onReorder;

  const ChecklistItemsEditor({
    super.key,
    required this.items,
    required this.focusedItemId,
    required this.canAdd,
    required this.onAdd,
    required this.onChanged,
    required this.onRemove,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: items.length,
          onReorderItem: onReorder,
          proxyDecorator: (child, index, animation) =>
              Material(color: Colors.transparent, child: child),
          itemBuilder: (context, index) {
            final item = items[index];
            return ChecklistItemField(
              key: ValueKey(item.id),
              item: item,
              index: index,
              autofocus: item.id == focusedItemId,
              onChanged: (text) => onChanged(item.id, text),
              onRemove: () => onRemove(item.id),
              onSubmitted: canAdd ? onAdd : () {},
            );
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: canAdd ? onAdd : null,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              canAdd ? l10n.checklistAddItem : l10n.checklistItemsLimit,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
