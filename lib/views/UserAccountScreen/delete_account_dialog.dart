import '../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class DeleteAccountDialog extends StatefulWidget {
  final AppLocalizations l10n;

  const DeleteAccountDialog({super.key, required this.l10n});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  late final TextEditingController _confirmTextController;

  @override
  void initState() {
    super.initState();
    _confirmTextController = TextEditingController();
  }

  @override
  void dispose() {
    _confirmTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortuguese = Localizations.localeOf(context).languageCode == 'pt';
    final requiredText = isPortuguese ? 'EXCLUIR' : 'DELETE';

    return StatefulBuilder(
      builder: (context, setDialogState) {
        final currentText = _confirmTextController.text.toUpperCase();
        final isConfirmTextValid = currentText == requiredText;

        return AlertDialog(
          backgroundColor: AppColors.surfaceElevated,
          title: Text(
            widget.l10n.deleteAccountConfirmTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.l10n.deleteAccountConfirmMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.l10n.deleteAccountConfirmItems,
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.l10n.deleteAccountWarning,
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.l10n.typeDeleteToConfirm,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmTextController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: requiredText,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isConfirmTextValid
                            ? AppColors.success
                            : AppColors.border,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isConfirmTextValid
                            ? AppColors.success
                            : AppColors.border,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isConfirmTextValid
                            ? AppColors.success
                            : Colors.red[400]!,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setDialogState(() {});
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                widget.l10n.cancel,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
            ElevatedButton(
              onPressed: isConfirmTextValid
                  ? () => Navigator.of(context).pop(true)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900]?.withValues(alpha: 0.2),
                foregroundColor: Colors.red[400],
                disabledBackgroundColor: AppColors.surface,
                disabledForegroundColor: Colors.grey[600],
              ),
              child: Text(widget.l10n.deleteAccount),
            ),
          ],
        );
      },
    );
  }
}
