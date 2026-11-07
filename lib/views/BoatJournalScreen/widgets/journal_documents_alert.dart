import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../RampBookingScreen/widgets/inline_alert.dart';

/// Aviso de documentos do barco vencidos ou vencendo; tocar leva à lista.
class JournalDocumentsAlert extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const JournalDocumentsAlert({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InlineAlert(
        icon: Icons.assignment_late_outlined,
        message: l10n.journalDocumentsAlert(count),
        color: AppColors.warning,
      ),
    );
  }
}
