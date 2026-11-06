import '../../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../RampBookingScreen/widgets/inline_alert.dart';

/// Aviso de que o sistema bloqueia as notificações do app, com o botão para
/// pedir a permissão.
class SystemPermissionAlert extends StatelessWidget {
  final VoidCallback onAllow;

  const SystemPermissionAlert({super.key, required this.onAllow});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InlineAlert(
            icon: Icons.notifications_off_outlined,
            message: l10n.notificationPrefsSystemBlocked,
            color: AppColors.warning,
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onAllow,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.notificationPrefsAllow),
          ),
        ],
      ),
    );
  }
}
