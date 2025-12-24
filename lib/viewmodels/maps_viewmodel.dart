import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/map_item.dart';

class MapsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<MapItem> _maps = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<QuerySnapshot>? _mapsStreamSubscription;

  List<MapItem> get maps => _maps;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MapsViewModel() {
    loadMaps();
  }

  Future<void> loadMaps() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mapsStreamSubscription?.cancel();

      final snapshot = await _firestore
          .collection('maps')
          .where('available', isEqualTo: true)
          .get();

      _maps = snapshot.docs.map((doc) => MapItem.fromFirestore(doc)).toList();

      _mapsStreamSubscription = _firestore
          .collection('maps')
          .where('available', isEqualTo: true)
          .snapshots()
          .listen(
            (snapshot) {
              _maps = snapshot.docs
                  .map((doc) => MapItem.fromFirestore(doc))
                  .toList();
              _errorMessage = null;
              _isLoading = false;
              notifyListeners();
            },
            onError: (error) {
              _errorMessage = 'Error loading maps: $error';
              _isLoading = false;
              notifyListeners();
            },
          );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading maps: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _mapsStreamSubscription?.cancel();
    super.dispose();
  }
}

