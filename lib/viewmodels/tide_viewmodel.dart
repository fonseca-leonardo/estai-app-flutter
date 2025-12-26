import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/tide_station.dart';
import '../services/tide_service.dart';
import '../services/maps_api_client.dart';

class TideViewModel extends ChangeNotifier {
  final TideService _tideService;

  List<TideStation> _tideStations = [];
  bool _isLoading = false;
  String? _errorMessage;

  TideViewModel({TideService? tideService})
      : _tideService = tideService ?? TideService();

  List<TideStation> get tideStations => _tideStations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTideStations({Position? userPosition}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tideStations = await _tideService.getTideStations();

      if (userPosition != null) {
        _sortStationsByDistance(userPosition);
      }

      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = 'errorLoadingTideTables:${e.statusCode ?? e.message}';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'errorLoadingTideTables:$e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _sortStationsByDistance(Position userPosition) {
    _tideStations.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        a.lat,
        a.lon,
      );
      final distanceB = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        b.lat,
        b.lon,
      );
      return distanceA.compareTo(distanceB);
    });
  }

  String getPdfUrl(int stationId) {
    return _tideService.getPdfUrl(stationId);
  }

  double? getDistanceToStation(TideStation station, Position? userPosition) {
    if (userPosition == null) return null;
    return Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      station.lat,
      station.lon,
    );
  }

  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }
}
