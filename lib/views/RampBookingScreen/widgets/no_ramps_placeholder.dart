import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Sem marina vinculada, sem rampa ativa ou erro ao carregar as rampas.
class NoRampsPlaceholder extends StatelessWidget {
  final bool hasNoMarina;
  final bool hasError;
  final VoidCallback onRetry;

  const NoRampsPlaceholder({
    super.key,
    required this.hasNoMarina,
    required this.hasError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String title;
    final String? description;
    if (hasNoMarina) {
      title = l10n.rampNoMarinaTitle;
      description = l10n.rampNoMarinaDescription;
    } else if (hasError) {
      title = l10n.rampLoadRampsError;
      description = null;
    } else {
      title = l10n.rampNoRampsTitle;
      description = l10n.rampNoRampsDescription;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasError && !hasNoMarina
                  ? Icons.cloud_off
                  : Icons.signpost_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
            ],
            if (hasError && !hasNoMarina) ...[
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Text(l10n.tryAgain),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
