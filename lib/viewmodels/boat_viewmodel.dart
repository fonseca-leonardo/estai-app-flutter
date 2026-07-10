import 'package:flutter/foundation.dart';
import '../models/boat.dart';
import '../models/boat_type.dart';

class BoatViewModel extends ChangeNotifier {
  final List<Boat> _boats = [];

  List<Boat> get boats => List.unmodifiable(_boats);

  void addBoat({
    required String name,
    required String model,
    required BoatType type,
    required int year,
    required double length,
  }) {
    final boat = Boat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      model: model,
      type: type,
      year: year,
      length: length,
    );
    _boats.insert(0, boat);
    notifyListeners();
  }

  void removeBoat(String id) {
    _boats.removeWhere((boat) => boat.id == id);
    notifyListeners();
  }

  void updateBoat(
    String id, {
    String? name,
    String? model,
    BoatType? type,
    int? year,
    double? length,
  }) {
    final index = _boats.indexWhere((boat) => boat.id == id);
    if (index == -1) return;
    _boats[index] = _boats[index].copyWith(
      name: name,
      model: model,
      type: type,
      year: year,
      length: length,
    );
    notifyListeners();
  }
}
