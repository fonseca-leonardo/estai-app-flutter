import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'routes_viewmodel.dart';

class RoutePlannerViewModel extends ChangeNotifier {
  List<LatLng> _routePoints = [];
  int? _draggingIndex;
  bool _hasConfirmedRoute = false;

  List<LatLng> get routePoints => _routePoints;
  int? get draggingIndex => _draggingIndex;
  bool get hasConfirmedRoute => _hasConfirmedRoute;

  void addRoutePoint(LatLng point) {
    _routePoints = [..._routePoints, point];
    notifyListeners();
  }

  void clearRoute() {
    _routePoints.clear();
    _hasConfirmedRoute = false;
    notifyListeners();
  }

  void confirmRoute() {
    if (_routePoints.length >= 2) {
      _hasConfirmedRoute = true;
      notifyListeners();
    }
  }

  void restoreRoute(List<LatLng> points) {
    _routePoints = List<LatLng>.from(points);
    _hasConfirmedRoute = _routePoints.length >= 2;
    notifyListeners();
  }

  Future<void> saveRoute(BuildContext context, String name) async {
    if (_routePoints.length < 2) {
      return;
    }
    
    final routesViewModel = Provider.of<RoutesViewModel>(context, listen: false);
    await routesViewModel.saveRoute(name, _routePoints);
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
