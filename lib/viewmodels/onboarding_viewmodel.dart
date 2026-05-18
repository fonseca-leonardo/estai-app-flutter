import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends ChangeNotifier {
  static const String _mapOnboardingKey = 'map_screen_onboarding_shown';

  bool _isInitialized = false;
  bool _shouldShowMapOnboarding = false;

  bool get isInitialized => _isInitialized;
  bool get shouldShowMapOnboarding => _shouldShowMapOnboarding;

  Future<void> loadMapOnboardingState() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    _shouldShowMapOnboarding = !(prefs.getBool(_mapOnboardingKey) ?? false);
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> markMapOnboardingShown() async {
    if (!_shouldShowMapOnboarding) return;
    _shouldShowMapOnboarding = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mapOnboardingKey, true);
  }

  @visibleForTesting
  Future<void> resetMapOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mapOnboardingKey);
    _shouldShowMapOnboarding = true;
    _isInitialized = true;
    notifyListeners();
  }
}
