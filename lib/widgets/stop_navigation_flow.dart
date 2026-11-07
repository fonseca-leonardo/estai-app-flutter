import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/boat.dart';
import '../models/checklist.dart';
import '../models/checklist_trigger.dart';
import '../models/trip_summary.dart';
import '../services/boat_cache_service.dart';
import '../services/checklist_storage_service.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/boat_viewmodel.dart';
import '../viewmodels/navigation_status_viewmodel.dart';
import '../views/ChecklistRunScreen/checklist_run_screen.dart';
import 'save_trip_sheet.dart';

/// Ponto único para encerrar uma navegação. Se a viagem valeu (tempo e
/// distância mínimos) e o usuário tem conta e barco, oferece salvá-la no
/// diário de bordo ([showSaveTripSheet]). Depois abre os checklists
/// "depois de navegar", se houver.
abstract final class StopNavigationFlow {
  static Future<void> stop(BuildContext context) async {
    final summary = context
        .read<NavigationStatusViewModel>()
        .finishNavigation();
    if (summary != null) await _offerSaveTrip(context, summary);
    if (!context.mounted) return;

    // Checklists "depois de navegar" aparecem sempre, mesmo em viagem
    // curta ou sem conta.
    List<Checklist> checklists;
    try {
      checklists = await ChecklistStorageService().getByTrigger(
        ChecklistTrigger.afterNavigation,
      );
    } catch (_) {
      checklists = const [];
    }
    if (checklists.isEmpty || !context.mounted) return;

    await ChecklistRunScreen.open(
      context,
      checklists: checklists,
      mode: ChecklistRunMode.afterNavigation,
    );
  }

  static Future<void> _offerSaveTrip(
    BuildContext context,
    TripSummary summary,
  ) async {
    if (!context.read<AuthViewModel>().isAuthenticated) return;

    // Cache-first: só espera a rede se ainda não houver barco em memória.
    final boatViewModel = context.read<BoatViewModel>();
    if (boatViewModel.boats.isEmpty) await boatViewModel.loadBoats();
    if (!context.mounted || boatViewModel.boats.isEmpty) return;

    Boat? preferred;
    try {
      final cache = BoatCacheService();
      preferred =
          await cache.getActiveMonitoringBoat() ??
          await cache.getLastSelectedBoat();
    } catch (_) {
      preferred = null;
    }
    if (!context.mounted) return;

    await showSaveTripSheet(
      context: context,
      summary: summary,
      boats: boatViewModel.boats,
      initialBoatId: preferred?.id,
    );
  }
}
