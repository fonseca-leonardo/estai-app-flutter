import 'dart:io';

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
    final logoFile = context.select<EstaiSessionViewModel, File?>(
      (vm) => vm.logoFile,
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
          if (logoFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                logoFile,
                key: ValueKey(logoFile.path),
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (context, error, stackTrace) =>
                    const _AnchorPlaceholder(),
              ),
            )
          else
            const _AnchorPlaceholder(),
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

class _AnchorPlaceholder extends StatelessWidget {
  const _AnchorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.anchor, color: Colors.white, size: 28),
    );
  }
}
