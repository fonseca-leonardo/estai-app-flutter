import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/marina.dart';
import '../services/boat_cache_service.dart';
import '../services/marina_storage_service.dart';
import '../viewmodels/boat_viewmodel.dart';
import '../viewmodels/navigation_status_viewmodel.dart';
import 'boat_selection_sheet.dart';

/// Ponto único de entrada para iniciar uma navegação. Usuários com marina
/// passam pela seleção de barco ([BoatSelectionSheet]) para ativar a monitoria;
/// os demais iniciam direto. Todo o fluxo é offline-safe: as consultas usam
/// apenas armazenamento local e a navegação nunca fica bloqueada por rede.
abstract final class StartNavigationFlow {
  /// Retorna `true` se a navegação foi iniciada.
  static Future<bool> start(
    BuildContext context, {
    List<LatLng>? plannedRoute,
  }) async {
    final navigationViewModel = Provider.of<NavigationStatusViewModel>(
      context,
      listen: false,
    );
    if (navigationViewModel.isNavigating) return false;

    Marina? marina;
    try {
      marina = await MarinaStorageService().getSaved();
    } catch (_) {
      marina = null;
    }
    if (!context.mounted) return false;

    if (marina == null) {
      navigationViewModel.startNavigation(plannedRoute: plannedRoute);
      return true;
    }

    // Cache-first: a sheet abre imediatamente com o que houver no cache
    // enquanto a rede atualiza a lista em background.
    final boatViewModel = Provider.of<BoatViewModel>(context, listen: false);
    unawaited(boatViewModel.loadBoats());

    final result = await BoatSelectionSheet.show(context, marinaId: marina.id);
    if (result == null || !context.mounted) return false;

    final boatCache = BoatCacheService();
    try {
      final boat = result.boat;
      if (boat != null) {
        await boatCache.saveLastSelectedBoat(boat);
        await boatCache.saveActiveMonitoringBoat(boat);
      } else {
        await boatCache.clearActiveMonitoringBoat();
      }
    } catch (_) {
      // Falha de storage não pode impedir o início da navegação.
    }

    navigationViewModel.startNavigation(plannedRoute: plannedRoute);
    return true;
  }
}
