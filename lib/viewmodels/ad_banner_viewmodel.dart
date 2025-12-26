import 'package:flutter/foundation.dart';

class AdBannerViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoaded = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void setLoaded(bool loaded) {
    if (_isLoaded != loaded) {
      _isLoaded = loaded;
      notifyListeners();
    }
  }

  void setError(String? error) {
    if (_errorMessage != error) {
      _errorMessage = error;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _isLoaded = false;
    _errorMessage = null;
    notifyListeners();
  }
}

