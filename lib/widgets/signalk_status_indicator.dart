import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/signalk_service.dart';
import '../viewmodels/signalk_connection_viewmodel.dart';

class SignalKStatusIndicator extends StatelessWidget {
  const SignalKStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SignalKConnectionViewModel, SignalKConnectionState>(
      selector: (_, vm) => vm.state,
      builder: (context, state, _) {
        if (state == SignalKConnectionState.disabled) {
          return const SizedBox.shrink();
        }

        final color = switch (state) {
          SignalKConnectionState.connected => const Color(0xFF22C55E),
          SignalKConnectionState.connecting => const Color(0xFFF59E0B),
          SignalKConnectionState.reconnecting => const Color(0xFFF59E0B),
          SignalKConnectionState.failed => const Color(0xFFEF4444),
          SignalKConnectionState.disabled => Colors.transparent,
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
