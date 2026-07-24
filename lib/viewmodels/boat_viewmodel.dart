import 'package:flutter/foundation.dart';
import '../models/boat.dart';
import '../models/boat_type.dart';
import '../services/boat_cache_service.dart';
import '../services/boat_service.dart';
import '../services/marina_storage_service.dart';

class BoatViewModel extends ChangeNotifier {
  BoatViewModel({
    BoatService? boatService,
    MarinaStorageService? marinaStorageService,
    BoatCacheService? boatCacheService,
  }) : _boatService = boatService ?? BoatService(),
       _marinaStorageService = marinaStorageService ?? MarinaStorageService(),
       _boatCacheService = boatCacheService ?? BoatCacheService();

  final BoatService _boatService;
  final MarinaStorageService _marinaStorageService;
  final BoatCacheService _boatCacheService;

  List<Boat> _boats = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  List<Boat> get boats => List.unmodifiable(_boats);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  /// Carrega os barcos com estratégia cache-first: o cache local é exibido
  /// imediatamente e a rede atualiza (e re-salva o cache) em seguida. Falha de
  /// rede com cache disponível é silenciosa, para a seleção de barco funcionar
  /// offline.
  Future<void> loadBoats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cached = await _boatCacheService.getBoats();
    if (cached.isNotEmpty) {
      _boats = cached;
      notifyListeners();
    }

    try {
      final result = await _boatService.getBoats();
      _boats = result.items;
      _isLoading = false;
      notifyListeners();
      await _boatCacheService.saveBoats(_boats);
    } catch (e) {
      _isLoading = false;
      if (_boats.isEmpty) {
        _errorMessage = e.toString();
      }
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
      await _boatCacheService.saveBoats(_boats);
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
      await _boatCacheService.saveBoats(_boats);
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
      await _boatCacheService.saveBoats(_boats);
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
      await _boatCacheService.saveBoats(_boats);
      return true;
    } catch (e) {
      _boats.insert(index, removedBoat);
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
