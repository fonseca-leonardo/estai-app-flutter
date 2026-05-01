import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class WatchConnectivityService {
  final WatchConnectivity _watch = WatchConnectivity();
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  bool _isSupported = false;
  bool _isPaired = false;
  bool _isReachable = false;

  bool get isSupported => _isSupported;
  bool get isPaired => _isPaired;
  bool get isReachable => _isReachable;

  Future<void> initialize() async {
    try {
      _isSupported = await _watch.isSupported;

      if (!_isSupported) {
        return;
      }

      _isPaired = await _watch.isPaired;
      _isReachable = await _watch.isReachable;

      _messageSubscription = _watch.messageStream.listen(
        _handleMessage,
        onError: (error) {},
      );
    } catch (e) {}
  }

  void _handleMessage(Map<String, dynamic> message) {}

  Future<void> sendNavigationData({
    required double? heading,
    required double? speed,
    required double distanceNauticalMiles,
    required bool isNavigating,
  }) async {
    if (!_isSupported || !_isPaired) {
      return;
    }

    try {
      final data = {
        'heading': heading ?? 0.0,
        'speed': speed ?? 0.0,
        'distance': distanceNauticalMiles,
        'isNavigating': isNavigating,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await _watch.sendMessage(data);
    } catch (e) {}
  }

  Future<void> updateApplicationContext({
    required double? heading,
    required double? speed,
    required double distanceNauticalMiles,
    required bool isNavigating,
  }) async {
    if (!_isSupported || !_isPaired) {
      return;
    }

    try {
      final context = {
        'heading': heading ?? 0.0,
        'speed': speed ?? 0.0,
        'distance': distanceNauticalMiles,
        'isNavigating': isNavigating,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await _watch.updateApplicationContext(context);
    } catch (e) {}
  }

  Future<void> checkReachability() async {
    if (!_isSupported) return;

    try {
      _isPaired = await _watch.isPaired;
      _isReachable = await _watch.isReachable;
    } catch (e) {}
  }

  void dispose() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
  }
}
