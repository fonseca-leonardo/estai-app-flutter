import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../BoatsListScreen/boats_list_screen.dart';
import '../../RampBookingScreen/ramp_booking_screen.dart';
import '../../ServiceOrderFormScreen/service_order_form_screen.dart';
import 'marina_quick_action_tile.dart';

/// O que o usuário pode fazer na marina, lado a lado.
class MarinaQuickActions extends StatelessWidget {
  const MarinaQuickActions({super.key});

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: MarinaQuickActionTile(
              icon: Icons.swap_vert,
              label: l10n.rampBookingTitle,
              onTap: () => _push(context, const RampBookingScreen()),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: MarinaQuickActionTile(
              icon: Icons.build_outlined,
              label: l10n.marinaActionServiceOrder,
              onTap: () => _push(context, const ServiceOrderFormScreen()),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: MarinaQuickActionTile(
              icon: Icons.directions_boat,
              label: l10n.myBoats,
              onTap: () => _push(context, const BoatsListScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
