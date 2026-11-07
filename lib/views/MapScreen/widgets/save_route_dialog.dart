import '../../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/dark_input_decoration.dart';
import '../../../widgets/ui/glass_dialog.dart';

class SaveRouteDialogResult {
  final String routeName;
  final bool saveForReuse;

  SaveRouteDialogResult({required this.routeName, required this.saveForReuse});
}

class SaveRouteDialog extends StatefulWidget {
  const SaveRouteDialog({super.key});

  @override
  State<SaveRouteDialog> createState() => _SaveRouteDialogState();

  static Future<SaveRouteDialogResult?> show(BuildContext context) {
    return showDialog<SaveRouteDialogResult>(
      context: context,
      builder: (context) => const SaveRouteDialog(),
    );
  }
}

class _SaveRouteDialogState extends State<SaveRouteDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _saveForReuse = true;
  bool _isNameValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    setState(() {
      _isNameValid = _saveForReuse
          ? _nameController.text.trim().isNotEmpty
          : true;
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassDialog(
      title: l10n.plannedRoute,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_saveForReuse) ...[
            TextField(
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: darkInputDecoration(l10n.routeName),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.saveRouteForReuse,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ),
              Switch(
                value: _saveForReuse,
                onChanged: (value) {
                  setState(() {
                    _saveForReuse = value;
                    _isNameValid = value
                        ? _nameController.text.trim().isNotEmpty
                        : true;
                  });
                },
                activeThumbColor: AppColors.accent,
              ),
            ],
          ),
        ],
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
          onPressed: _isNameValid
              ? () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.of(context).pop(
                    SaveRouteDialogResult(
                      routeName: _saveForReuse
                          ? _nameController.text.trim()
                          : '',
                      saveForReuse: _saveForReuse,
                    ),
                  );
                }
              : null,
          child: Text(
            l10n.confirm,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _isNameValid ? AppColors.success : AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
