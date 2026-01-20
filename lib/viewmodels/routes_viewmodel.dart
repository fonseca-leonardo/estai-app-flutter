import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/route.dart';

class RoutesViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _localRoutesKey = 'local_routes';

  List<Route> _routes = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<QuerySnapshot>? _routesStreamSubscription;

  List<Route> get routes => _routes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  RoutesViewModel() {
    _initialize();
  }

  void _initialize() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _migrateLocalRoutesToFirestore(user.uid);
        _loadRoutes();
      } else {
        _loadRoutes();
      }
    });
    _loadRoutes();
  }

  Future<void> _migrateLocalRoutesToFirestore(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localRoutesJson = prefs.getString(_localRoutesKey);

      if (localRoutesJson == null || localRoutesJson.isEmpty) {
        return;
      }

      final List<dynamic> localRoutesList = json.decode(localRoutesJson);
      if (localRoutesList.isEmpty) {
        return;
      }

      final routesCollection = _firestore
          .collection('estai')
          .doc(userId)
          .collection('routes');

      for (final routeMap in localRoutesList) {
        final route = Route.fromMap(routeMap as Map<String, dynamic>);
        await routesCollection.doc(route.id).set(route.toFirestore());
      }

      await prefs.remove(_localRoutesKey);
      notifyListeners();
    } catch (e) {
      debugPrint('Error migrating local routes to Firestore: $e');
    }
  }

  Future<void> saveRoute(String name, List<LatLng> points) async {
    if (points.length < 2) {
      _errorMessage = 'Route must have at least 2 points';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      final now = DateTime.now();
      final routeId = user != null
          ? routesCollection(user.uid).doc().id
          : DateTime.now().millisecondsSinceEpoch.toString();

      final route = Route(
        id: routeId,
        name: name,
        points: points,
        createdAt: now,
        updatedAt: now,
      );

      if (user != null) {
        try {
          await routesCollection(
            user.uid,
          ).doc(routeId).set(route.toFirestore());
        } catch (firestoreError) {
          debugPrint(
            'Error saving to Firestore, saving locally: $firestoreError',
          );
          await _saveToLocalStorage(route);
        }
      } else {
        await _saveToLocalStorage(route);
      }

      _isLoading = false;
      await _loadRoutes();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error saving route: $e';
      debugPrint('Error in saveRoute: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _saveToLocalStorage(Route route) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localRoutesJson = prefs.getString(_localRoutesKey);

      List<Map<String, dynamic>> routesList = [];
      if (localRoutesJson != null && localRoutesJson.isNotEmpty) {
        routesList = List<Map<String, dynamic>>.from(
          json.decode(localRoutesJson) as List,
        );
      }

      routesList.add(route.toMap());
      await prefs.setString(_localRoutesKey, json.encode(routesList));
    } catch (e) {
      debugPrint('Error saving route to local storage: $e');
      rethrow;
    }
  }

  Future<void> _loadRoutes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _auth.currentUser;

      if (user != null) {
        await _loadFromFirestore(user.uid);
      } else {
        await _loadFromLocalStorage();
      }
    } catch (e) {
      _errorMessage = 'Error loading routes: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromFirestore(String userId) async {
    _routesStreamSubscription?.cancel();

    try {
      final snapshot = await routesCollection(
        userId,
      ).orderBy('createdAt', descending: true).get();

      _routes = snapshot.docs.map((doc) => Route.fromFirestore(doc)).toList();

      _routesStreamSubscription = routesCollection(userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              _routes = snapshot.docs
                  .map((doc) => Route.fromFirestore(doc))
                  .toList();
              _errorMessage = null;
              notifyListeners();
            },
            onError: (error) {
              _errorMessage = 'Error loading routes: $error';
              notifyListeners();
            },
          );
    } catch (e) {
      _errorMessage = 'Error loading routes: $e';
      rethrow;
    }
  }

  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localRoutesJson = prefs.getString(_localRoutesKey);

      if (localRoutesJson == null || localRoutesJson.isEmpty) {
        _routes = [];
        return;
      }

      final List<dynamic> routesList = json.decode(localRoutesJson);
      _routes = routesList
          .map((routeMap) => Route.fromMap(routeMap as Map<String, dynamic>))
          .toList();

      _routes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _routes = [];
      debugPrint('Error loading routes from local storage: $e');
    }
  }

  CollectionReference routesCollection(String userId) {
    return _firestore.collection('estai').doc(userId).collection('routes');
  }

  Future<void> deleteRoute(String routeId) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _auth.currentUser;

      if (user != null) {
        await routesCollection(user.uid).doc(routeId).delete();
      } else {
        await _deleteFromLocalStorage(routeId);
      }

      await _loadRoutes();
    } catch (e) {
      _errorMessage = 'Error deleting route: $e';
      notifyListeners();
    }
  }

  Future<void> _deleteFromLocalStorage(String routeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localRoutesJson = prefs.getString(_localRoutesKey);

      if (localRoutesJson == null || localRoutesJson.isEmpty) {
        return;
      }

      final List<dynamic> routesList = json.decode(localRoutesJson);
      routesList.removeWhere(
        (routeMap) => (routeMap as Map<String, dynamic>)['id'] == routeId,
      );

      await prefs.setString(_localRoutesKey, json.encode(routesList));
    } catch (e) {
      debugPrint('Error deleting route from local storage: $e');
      rethrow;
    }
  }

  Future<void> updateRoute(String routeId, String name) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _auth.currentUser;

      if (user != null) {
        await routesCollection(
          user.uid,
        ).doc(routeId).update({'name': name, 'updatedAt': Timestamp.now()});
      } else {
        await _updateInLocalStorage(routeId, name);
      }

      await _loadRoutes();
    } catch (e) {
      _errorMessage = 'Error updating route: $e';
      notifyListeners();
    }
  }

  Future<void> _updateInLocalStorage(String routeId, String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localRoutesJson = prefs.getString(_localRoutesKey);

      if (localRoutesJson == null || localRoutesJson.isEmpty) {
        return;
      }

      final List<dynamic> routesList = json.decode(localRoutesJson);
      for (int i = 0; i < routesList.length; i++) {
        final routeMap = routesList[i] as Map<String, dynamic>;
        if (routeMap['id'] == routeId) {
          routeMap['name'] = name;
          routeMap['updatedAt'] = DateTime.now().toIso8601String();
          break;
        }
      }

      await prefs.setString(_localRoutesKey, json.encode(routesList));
    } catch (e) {
      debugPrint('Error updating route in local storage: $e');
      rethrow;
    }
  }

  Future<void> deleteAllUserRoutes(String userId) async {
    try {
      // Delete all routes from Firestore
      final routesSnapshot = await routesCollection(userId).get();
      final batch = _firestore.batch();
      for (final doc in routesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Clear local routes from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localRoutesKey);

      // Clear local state
      _routes = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting all user routes: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _routesStreamSubscription?.cancel();
    super.dispose();
  }
}
