import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/date_picker_field.dart';
import '../../../widgets/ui/app_card.dart';

/// Emissão e validade. Sem validade, o documento não gera aviso.
class DocumentDatesCard extends StatelessWidget {
  final DateTime? issuedAt;
  final DateTime? expiresAt;
  final bool showInvalidDatesError;
  final VoidCallback onPickIssuedAt;
  final VoidCallback onClearIssuedAt;
  final VoidCallback onPickExpiresAt;
  final VoidCallback onClearExpiresAt;

  const DocumentDatesCard({
    super.key,
    required this.issuedAt,
    required this.expiresAt,
    required this.showInvalidDatesError,
    required this.onPickIssuedAt,
    required this.onClearIssuedAt,
    required this.onPickExpiresAt,
    required this.onClearExpiresAt,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DatePickerField(
            label: l10n.documentExpiresAtLabel,
            value: expiresAt,
            placeholder: l10n.documentNoExpiryLabel,
            onTap: onPickExpiresAt,
            onClear: onClearExpiresAt,
            errorText: showInvalidDatesError
                ? l10n.documentInvalidDatesError
                : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          DatePickerField(
            label: l10n.documentIssuedAtLabel,
            value: issuedAt,
            placeholder: l10n.documentDateNotInformed,
            onTap: onPickIssuedAt,
            onClear: onClearIssuedAt,
          ),
        ],
      ),
    );
  }
}
