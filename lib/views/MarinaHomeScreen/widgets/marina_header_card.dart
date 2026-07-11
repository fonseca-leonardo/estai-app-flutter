import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/estai_session_viewmodel.dart';

class MarinaHeaderCard extends StatelessWidget {
  const MarinaHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final marinaName = context.select<EstaiSessionViewModel, String?>(
      (vm) => vm.activeMarina?.name,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.anchor, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              marinaName ?? '—',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
