import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/checklist.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/dark_input_decoration.dart';

/// Campo de um item, com alça para arrastar e botão de remover. Guarda o
/// próprio controller para manter o texto ao reordenar.
class ChecklistItemField extends StatefulWidget {
  final ChecklistItem item;
  final int index;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;
  final VoidCallback onSubmitted;

  const ChecklistItemField({
    super.key,
    required this.item,
    required this.index,
    required this.autofocus,
    required this.onChanged,
    required this.onRemove,
    required this.onSubmitted,
  });

  @override
  State<ChecklistItemField> createState() => _ChecklistItemFieldState();
}

class _ChecklistItemFieldState extends State<ChecklistItemField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.item.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: widget.index,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.drag_indicator, color: AppColors.textTertiary),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              maxLength: Checklist.maxItemLength,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              style: const TextStyle(color: Colors.white),
              decoration: darkInputDecoration(
                l10n.checklistItemHint,
              ).copyWith(counterText: ''),
              onChanged: widget.onChanged,
              onSubmitted: (_) => widget.onSubmitted(),
            ),
          ),
          IconButton(
            tooltip: l10n.checklistRemoveItem,
            onPressed: widget.onRemove,
            icon: Icon(Icons.close, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
