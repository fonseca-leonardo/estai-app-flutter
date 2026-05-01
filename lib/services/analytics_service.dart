import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  static const String anonymousUserId = 'anonymous';

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> initialize() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
    await syncCurrentUser();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      syncCurrentUser(user: user);
    });
  }

  Future<void> syncCurrentUser({User? user}) async {
    final current = user ?? FirebaseAuth.instance.currentUser;
    final id = current?.uid ?? anonymousUserId;
    final isAnonymous = current == null;
    try {
      await _analytics.setUserId(id: id);
      await _analytics.setUserProperty(
        name: 'auth_status',
        value: isAnonymous ? 'anonymous' : 'authenticated',
      );
    } catch (e) {}
  }

  Future<void> logScreenView(String screenName) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? anonymousUserId;
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenName,
        parameters: {'user_id': userId},
      );
    } catch (e) {}
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? anonymousUserId;
    final params = <String, Object>{'user_id': userId, ...?parameters};
    try {
      await _analytics.logEvent(name: name, parameters: params);
    } catch (e) {}
  }
}
