import 'package:flutter/foundation.dart';
import '../models/boat.dart';
import '../models/marina.dart';
import '../services/boat_service.dart';
import '../services/marina_service.dart';
import '../services/marina_storage_service.dart';

class MarinaAccessViewModel extends ChangeNotifier {
  MarinaAccessViewModel({
    MarinaService? marinaService,
    BoatService? boatService,
    MarinaStorageService? marinaStorageService,
  }) : _marinaService = marinaService ?? MarinaService(),
       _boatService = boatService ?? BoatService(),
       _marinaStorageService = marinaStorageService ?? MarinaStorageService();

  final MarinaService _marinaService;
  final BoatService _boatService;
  final MarinaStorageService _marinaStorageService;

  Marina? _marina;
  List<Boat> _boats = [];
  final Set<String> _selectedBoatIds = {};
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  Marina? _associationResult;

  Marina? get marina => _marina;
  List<Boat> get boats => List.unmodifiable(_boats);
  Set<String> get selectedBoatIds => Set.unmodifiable(_selectedBoatIds);
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  Marina? get associationResult => _associationResult;

  Future<void> loadData(String marinaId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _marinaService.getMarina(marinaId),
        _boatService.getBoats(),
      ]);
      _marina = results[0] as Marina;
      _boats = (results[1] as BoatListResult).items;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void toggleBoat(String boatId) {
    if (_selectedBoatIds.contains(boatId)) {
      _selectedBoatIds.remove(boatId);
    } else {
      _selectedBoatIds.add(boatId);
    }
    notifyListeners();
  }

  Future<bool> confirmAssociation(String marinaId) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final marina = await _marinaService.giveMarinaAccess(
        marinaId: marinaId,
        boatIds: _selectedBoatIds.toList(),
      );
      await _marinaStorageService.save(marina);
      _associationResult = marina;
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSubmitting = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
