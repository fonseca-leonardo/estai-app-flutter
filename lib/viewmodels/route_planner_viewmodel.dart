import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class RoutePlannerViewModel extends ChangeNotifier {
  List<LatLng> _routePoints = [];
  LatLng? _pendingPoint;
  int? _draggingIndex;
  bool _hasConfirmedRoute = false;

  List<LatLng> get routePoints => _routePoints;
  LatLng? get pendingPoint => _pendingPoint;
  int? get draggingIndex => _draggingIndex;
  bool get hasConfirmedRoute => _hasConfirmedRoute;

  void setPendingPoint(LatLng point) {
    _pendingPoint = point;
    notifyListeners();
  }

  void confirmPendingPoint() {
    if (_pendingPoint != null) {
      _routePoints = [..._routePoints, _pendingPoint!];
      _pendingPoint = null;
      notifyListeners();
    }
  }

  void cancelPendingPoint() {
    _pendingPoint = null;
    notifyListeners();
  }

  void addRoutePoint(LatLng point) {
    _routePoints = [..._routePoints, point];
    notifyListeners();
  }

  void clearRoute() {
    _routePoints.clear();
    _pendingPoint = null;
    _hasConfirmedRoute = false;
    notifyListeners();
  }

  void confirmRoute() {
    if (_routePoints.length >= 2) {
      _hasConfirmedRoute = true;
      notifyListeners();
    }
  }

  void removeLastPoint() {
    if (_routePoints.isNotEmpty) {
      _routePoints = _routePoints.sublist(0, _routePoints.length - 1);
      notifyListeners();
    }
  }

  void updateRoutePoint(int index, LatLng newPoint) {
    if (index >= 0 && index < _routePoints.length) {
      final updatedPoints = List<LatLng>.from(_routePoints);
      updatedPoints[index] = newPoint;
      _routePoints = updatedPoints;
      notifyListeners();
    }
  }

  void startDragging(int index) {
    _draggingIndex = index;
    notifyListeners();
  }

  void stopDragging() {
    _draggingIndex = null;
    notifyListeners();
  }
}
