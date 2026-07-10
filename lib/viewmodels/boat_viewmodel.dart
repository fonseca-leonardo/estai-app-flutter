import 'package:flutter/foundation.dart';
import '../models/boat.dart';
import '../models/boat_type.dart';
import '../services/boat_service.dart';
import '../services/marina_storage_service.dart';

class BoatViewModel extends ChangeNotifier {
  BoatViewModel({BoatService? boatService, MarinaStorageService? marinaStorageService})
    : _boatService = boatService ?? BoatService(),
      _marinaStorageService = marinaStorageService ?? MarinaStorageService();

  final BoatService _boatService;
  final MarinaStorageService _marinaStorageService;

  List<Boat> _boats = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  List<Boat> get boats => List.unmodifiable(_boats);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  Future<void> loadBoats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _boatService.getBoats();
      _boats = result.items;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> addBoat({
    required String name,
    required String model,
    required BoatType type,
    required int year,
    required double length,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final boat = await _boatService.createBoat(
        name: name,
        model: model,
        type: type,
        year: year,
        length: length,
      );
      _boats.insert(0, boat);
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBoat(
    String id, {
    String? name,
    String? model,
    BoatType? type,
    int? year,
    double? length,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedBoat = await _boatService.updateBoat(
        id,
        name: name,
        model: model,
        type: type,
        year: year,
        length: length,
      );
      final index = _boats.indexWhere((boat) => boat.id == id);
      if (index != -1) {
        _boats[index] = updatedBoat;
      }
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> setMarinaAccess(String id, bool access) async {
    _errorMessage = null;
    final index = _boats.indexWhere((boat) => boat.id == id);
    final previousBoat = index != -1 ? _boats[index] : null;

    if (index != -1) {
      final marinaId = access
          ? (await _marinaStorageService.getSaved())?.id
          : null;
      _boats[index] = previousBoat!.copyWith(
        marinaId: marinaId,
        clearMarinaId: marinaId == null,
      );
      notifyListeners();
    }

    try {
      await _boatService.giveBoatToMarina(boatId: id, access: access);
      return true;
    } catch (e) {
      if (index != -1) {
        _boats[index] = previousBoat!;
      }
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeBoat(String id) async {
    _errorMessage = null;
    final index = _boats.indexWhere((boat) => boat.id == id);
    if (index == -1) return false;

    final removedBoat = _boats.removeAt(index);
    notifyListeners();

    try {
      await _boatService.deleteBoat(id);
      return true;
    } catch (e) {
      _boats.insert(index, removedBoat);
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
