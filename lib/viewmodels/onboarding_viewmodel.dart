import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends ChangeNotifier {
  static const String _mapOnboardingKey = 'map_screen_onboarding_shown';

  bool _isInitialized = false;
  bool _shouldShowMapOnboarding = false;

  bool _isShowingMapOnboarding = false;

  bool get isInitialized => _isInitialized;
  bool get shouldShowMapOnboarding => _shouldShowMapOnboarding;

  /// Reserva a exibição do onboarding do mapa. Devolve `false` se já foi
  /// visto ou se outra instância do mapa já o está mostrando.
  bool beginMapOnboarding() {
    if (!_shouldShowMapOnboarding || _isShowingMapOnboarding) return false;
    _isShowingMapOnboarding = true;
    return true;
  }

  void endMapOnboarding() {
    _isShowingMapOnboarding = false;
  }

  /// Relê o storage a cada abertura do mapa: o logout apaga a marcação
  /// ([clearPersisted]) para o tour voltar no próximo login.
  Future<void> loadMapOnboardingState() async {
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

  /// Esquece que o tour já foi visto (chamado no logout).
  static Future<void> clearPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mapOnboardingKey);
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
