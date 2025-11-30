import 'dart:async';
import 'package:flutter/foundation.dart';

class NavigationStatusViewModel extends ChangeNotifier {
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isNavigating = false;
  DateTime? _startTime;

  Duration get elapsedTime => _elapsedTime;
  bool get isNavigating => _isNavigating;

  String get formattedTime {
    final hours = _elapsedTime.inHours.toString().padLeft(2, '0');
    final minutes = (_elapsedTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsedTime.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void startNavigation() {
    if (_isNavigating) return;

    _isNavigating = true;
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        _elapsedTime = DateTime.now().difference(_startTime!);
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void stopNavigation() {
    _timer?.cancel();
    _timer = null;
    _isNavigating = false;
    notifyListeners();
  }

  void resetNavigation() {
    _timer?.cancel();
    _timer = null;
    _elapsedTime = Duration.zero;
    _isNavigating = false;
    _startTime = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

