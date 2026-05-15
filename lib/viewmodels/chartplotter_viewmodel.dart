import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../models/chart_boundary.dart';
import '../services/chart_boundary_service.dart';

class ChartplotterViewModel extends ChangeNotifier {
  ChartplotterViewModel({ChartBoundaryService? service})
    : _service = service ?? ChartBoundaryService.instance {
    _load();
  }

  final ChartBoundaryService _service;

  List<ChartBoundary> _allBoundaries = const [];
  LatLng? _center;
  bool _isLoaded = false;

  List<ChartBoundary> get allBoundaries => _allBoundaries;
  LatLng? get center => _center;
  bool get isLoaded => _isLoaded;

  List<ChartBoundary> get selectedCharts {
    final c = _center;
    if (c == null) return const [];
    final lat = c.latitude;
    final lon = c.longitude;
    return _allBoundaries
        .where(
          (b) =>
              lat >= b.minLat &&
              lat <= b.maxLat &&
              lon >= b.minLon &&
              lon <= b.maxLon,
        )
        .toList(growable: false);
  }

  Future<void> _load() async {
    _allBoundaries = await _service.loadAll();
    _isLoaded = true;
    notifyListeners();
  }

  void updateCenter(LatLng center) {
    final current = _center;
    if (current != null &&
        current.latitude == center.latitude &&
        current.longitude == center.longitude) {
      return;
    }
    _center = center;
    notifyListeners();
  }
}
