import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/dark_input_decoration.dart';
import '../../../widgets/ui/glass_dialog.dart';

/// Novo nome da rota, ou `null` se cancelou.
Future<String?> showEditRouteNameDialog(
  BuildContext context, {
  required String currentName,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => EditRouteNameDialog(currentName: currentName),
  );
}

class EditRouteNameDialog extends StatefulWidget {
  final String currentName;

  const EditRouteNameDialog({super.key, required this.currentName});

  @override
  State<EditRouteNameDialog> createState() => _EditRouteNameDialogState();
}

class _EditRouteNameDialogState extends State<EditRouteNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassDialog(
      title: l10n.editRouteName,
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        style: const TextStyle(color: Colors.white),
        decoration: darkInputDecoration(l10n.routeName),
        onSubmitted: (_) => _confirm(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop();
          },
          child: Text(
            l10n.cancel,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: _confirm,
          child: Text(
            l10n.confirm,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
