import '../../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../RampBookingScreen/widgets/inline_alert.dart';

/// Aviso de manutenções atrasadas; tocar leva à lista.
class JournalOverdueAlert extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const JournalOverdueAlert({
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
        icon: Icons.error_outline,
        message: l10n.journalOverdueAlert(count),
        color: AppColors.danger,
      ),
    );
  }
}
