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
        if (kDebugMode) {
          print('Watch Connectivity is not supported on this device');
        }
        return;
      }

      _isPaired = await _watch.isPaired;
      _isReachable = await _watch.isReachable;

      if (kDebugMode) {
        print(
          'Watch - Supported: $_isSupported, Paired: $_isPaired, Reachable: $_isReachable',
        );
      }

      _messageSubscription = _watch.messageStream.listen(
        _handleMessage,
        onError: (error) {
          if (kDebugMode) {
            print('Error receiving message from watch: $error');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Watch Connectivity: $e');
      }
    }
  }

  void _handleMessage(Map<String, dynamic> message) {
    if (kDebugMode) {
      print('Received message from watch: $message');
    }
  }

  Future<void> sendNavigationData({
    required double? heading,
    required double? speed,
    required double distanceNauticalMiles,
    required bool isNavigating,
  }) async {
    if (!_isSupported || !_isPaired) {
      if (kDebugMode) {
        print('Cannot send data: Watch not supported or paired');
      }
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

      if (kDebugMode) {
        print('Sent navigation data to watch: $data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending data to watch: $e');
      }
    }
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

      if (kDebugMode) {
        print('Updated application context on watch');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating application context: $e');
      }
    }
  }

  Future<void> checkReachability() async {
    if (!_isSupported) return;

    try {
      _isPaired = await _watch.isPaired;
      _isReachable = await _watch.isReachable;

      if (kDebugMode) {
        print('Watch status - Paired: $_isPaired, Reachable: $_isReachable');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking watch reachability: $e');
      }
    }
  }

  void dispose() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
  }
}
