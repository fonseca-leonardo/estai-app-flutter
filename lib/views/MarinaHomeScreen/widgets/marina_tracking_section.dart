import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/ramp_schedule_viewmodel.dart';
import '../../../viewmodels/service_order_viewmodel.dart';
import 'recent_service_orders_list.dart';
import 'tracking_segment.dart';
import 'upcoming_ramp_schedules_list.dart';

enum MarinaTrackingTab { ramp, services }

/// Acompanhamento: alterna entre os agendamentos de rampa e as ordens de
/// serviço, cada um com seu contador de itens em aberto.
class MarinaTrackingSection extends StatefulWidget {
  const MarinaTrackingSection({super.key});

  @override
  State<MarinaTrackingSection> createState() => _MarinaTrackingSectionState();
}

class _MarinaTrackingSectionState extends State<MarinaTrackingSection> {
  MarinaTrackingTab _tab = MarinaTrackingTab.ramp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rampCount = context.select<RampScheduleViewModel, int>(
      (vm) => vm.activeUpcoming.length,
    );
    final serviceCount = context.select<ServiceOrderViewModel, int>(
      (vm) => vm.orders.where((order) => order.status.isCancellable).length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TrackingSegment(
                  icon: Icons.swap_vert,
                  label: l10n.marinaTrackingRamp,
                  count: rampCount,
                  selected: _tab == MarinaTrackingTab.ramp,
                  onTap: () => setState(() => _tab = MarinaTrackingTab.ramp),
                ),
              ),
              Expanded(
                child: TrackingSegment(
                  icon: Icons.build_outlined,
                  label: l10n.marinaTrackingServices,
                  count: serviceCount,
                  selected: _tab == MarinaTrackingTab.services,
                  onTap: () =>
                      setState(() => _tab = MarinaTrackingTab.services),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _tab == MarinaTrackingTab.ramp
              ? const UpcomingRampSchedulesList(key: ValueKey('ramp'))
              : const RecentServiceOrdersList(key: ValueKey('services')),
        ),
      ],
    );
  }
}
