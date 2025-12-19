import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/tide_station.dart';

class TideViewModel extends ChangeNotifier {
  List<TideStation> _tideStations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TideStation> get tideStations => _tideStations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTideStations({Position? userPosition}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://nizz-web-charter.vercel.app/tides/list'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as List<dynamic>;

        _tideStations = data
            .map((item) => TideStation.fromJson(item as Map<String, dynamic>))
            .toList();

        if (userPosition != null) {
          _sortStationsByDistance(userPosition);
        }

        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage =
            'errorLoadingTideTables:${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
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
    return 'https://nizz-web-charter.vercel.app/tides/$stationId/pdf';
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
