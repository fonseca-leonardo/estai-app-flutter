import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class NavigationPermissionViewModel extends ChangeNotifier {
  LocationPermission? _permission;
  bool _isLoading = true;

  LocationPermission? get permission => _permission;
  bool get isLoading => _isLoading;
  bool get showOpenSettingsButton =>
      _permission != null && _permission != LocationPermission.always;

  NavigationPermissionViewModel() {
    loadPermission();
  }

  Future<void> loadPermission() async {
    _isLoading = true;
    notifyListeners();
    try {
      _permission = await Geolocator.checkPermission();
    } catch (e) {
      _permission = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }
}
