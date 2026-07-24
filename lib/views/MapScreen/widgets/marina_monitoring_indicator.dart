import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/marina_monitoring_service.dart';
import '../../../viewmodels/marina_monitoring_viewmodel.dart';

/// Indicador discreto do estado da monitoria da marina durante a navegação.
/// Fica invisível quando a monitoria está desativada; falhas viram apenas um
/// ponto vermelho, sem toasts ou erros que atrapalhem a navegação.
class MarinaMonitoringIndicator extends StatelessWidget {
  const MarinaMonitoringIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MarinaMonitoringViewModel, MarinaMonitoringState>(
      selector: (_, vm) => vm.state,
      builder: (context, state, _) {
        if (state == MarinaMonitoringState.disabled) {
          return const SizedBox.shrink();
        }

        final color = switch (state) {
          MarinaMonitoringState.connected => const Color(0xFF3B82F6),
          MarinaMonitoringState.connecting => const Color(0xFFF59E0B),
          MarinaMonitoringState.reconnecting => const Color(0xFFF59E0B),
          MarinaMonitoringState.failed => const Color(0xFFEF4444),
          MarinaMonitoringState.disabled => Colors.transparent,
        };

        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
