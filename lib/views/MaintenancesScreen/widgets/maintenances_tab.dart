import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/maintenance.dart';
import 'maintenance_card.dart';

/// Uma aba da lista (próximas ou histórico) com pull-to-refresh.
class MaintenancesTab extends StatelessWidget {
  final List<Maintenance> maintenances;
  final bool isLoading;
  final String? errorMessage;
  final String emptyMessage;
  final double? currentEngineHours;
  final String? highlightedId;
  final Future<void> Function() onRefresh;
  final ValueChanged<Maintenance> onOpen;
  final ValueChanged<Maintenance>? onComplete;
  final EdgeInsets padding;

  const MaintenancesTab({
    super.key,
    required this.maintenances,
    required this.isLoading,
    required this.errorMessage,
    required this.emptyMessage,
    required this.currentEngineHours,
    this.highlightedId,
    required this.onRefresh,
    required this.onOpen,
    this.onComplete,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading && maintenances.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final String? message = errorMessage != null && maintenances.isEmpty
        ? l10n.loadMaintenancesError
        : (maintenances.isEmpty ? emptyMessage : null);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Colors.black,
      backgroundColor: Colors.white,
      child: message != null
          ? ListView(
              padding: padding,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 80),
                Icon(
                  Icons.build_circle_outlined,
                  size: 56,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                ),
              ],
            )
          : ListView.builder(
              padding: padding,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: maintenances.length,
              itemBuilder: (context, index) {
                final maintenance = maintenances[index];
                final complete = onComplete;
                return MaintenanceCard(
                  maintenance: maintenance,
                  currentEngineHours: currentEngineHours,
                  highlighted: maintenance.id == highlightedId,
                  onTap: () => onOpen(maintenance),
                  onComplete: complete != null
                      ? () => complete(maintenance)
                      : null,
                );
              },
            ),
    );
  }
}
