import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class MapViewModel extends ChangeNotifier {
  Position? _currentPosition;
  bool _isLoading = false;
  String? _errorMessage;
  bool _showCustomTiles = true;
  bool _isCameraLocked = false;
  bool _isPlanningRoute = false;
  StreamSubscription<Position>? _positionStreamSubscription;

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get showCustomTiles => _showCustomTiles;
  bool get isCameraLocked => _isCameraLocked;
  bool get isPlanningRoute => _isPlanningRoute;

  double? get currentSpeed => _currentPosition?.speed;
  double? get currentHeading => _currentPosition?.heading;

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Verificar permissões
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'locationServicesDisabled';
        _isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'locationPermissionDenied';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'locationPermissionDeniedForever';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Obter localização atual uma vez para inicialização rápida
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _isLoading = false;
      notifyListeners();

      // Iniciar stream de atualizações contínuas
      _startLocationStream();
    } catch (e) {
      _errorMessage = 'errorGettingLocation:$e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startLocationStream() {
    _positionStreamSubscription?.cancel();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _currentPosition = position;
            _errorMessage = null;
            notifyListeners();
          },
          onError: (error) {
            _errorMessage = 'errorUpdatingLocation:$error';
            notifyListeners();
          },
        );
  }

  void stopLocationStream() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  @override
  void dispose() {
    stopLocationStream();
    super.dispose();
  }

  Future<void> refreshLocation() async {
    await getCurrentLocation();
  }

  void toggleCustomTiles() {
    _showCustomTiles = !_showCustomTiles;
    notifyListeners();
  }

  void toggleCameraLock() {
    _isCameraLocked = !_isCameraLocked;
    notifyListeners();
  }

  void setIsPlanningRoute(bool isPlanning) {
    _isPlanningRoute = isPlanning;
    notifyListeners();
  }
}
