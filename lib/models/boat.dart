import 'boat_type.dart';

class Boat {
  final String id;
  final String name;
  final String model;
  final BoatType type;
  final int year;
  final double length;

  Boat({
    required this.id,
    required this.name,
    required this.model,
    required this.type,
    required this.year,
    required this.length,
  });

  Boat copyWith({
    String? name,
    String? model,
    BoatType? type,
    int? year,
    double? length,
  }) {
    return Boat(
      id: id,
      name: name ?? this.name,
      model: model ?? this.model,
      type: type ?? this.type,
      year: year ?? this.year,
      length: length ?? this.length,
    );
  }

  factory Boat.fromJson(Map<String, dynamic> json) {
    return Boat(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      type: BoatType.fromApiValue(json['type'] as String),
      year: json['year'] as int,
      length: (json['length'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'type': type.apiValue,
      'year': year,
      'length': length,
    };
  }
}
