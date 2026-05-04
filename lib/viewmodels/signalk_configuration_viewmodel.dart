import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignalKConfigurationViewModel extends ChangeNotifier {
  static const String _hostKey = 'signalk_host';
  static const String _tokenKey = 'signalk_token';

  String _host = '';
  String _token = '';
  bool _isLoading = true;

  String get host => _host;
  String get token => _token;
  bool get isLoading => _isLoading;
  bool get isConfigured => _host.trim().isNotEmpty;

  SignalKConfigurationViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _host = prefs.getString(_hostKey) ?? '';
      _token = prefs.getString(_tokenKey) ?? '';
    } catch (_) {
      _host = '';
      _token = '';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> save({required String host, required String token}) async {
    final trimmedHost = host.trim();
    final trimmedToken = token.trim();

    _host = trimmedHost;
    _token = trimmedToken;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_hostKey, trimmedHost);
      await prefs.setString(_tokenKey, trimmedToken);
    } catch (_) {
      // Persistence errors are ignored; values stay in-memory.
    }
  }

  Future<void> clear() async {
    _host = '';
    _token = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_hostKey);
      await prefs.remove(_tokenKey);
    } catch (_) {
      // ignore
    }
  }
}
