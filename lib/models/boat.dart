import 'boat_type.dart';

class Boat {
  final String id;
  final String name;
  final String model;
  final BoatType type;
  final int year;
  final double length;
  final String? marinaId;

  /// Última leitura do horímetro do motor, se o usuário já informou.
  final double? engineHours;

  Boat({
    required this.id,
    required this.name,
    required this.model,
    required this.type,
    required this.year,
    required this.length,
    this.marinaId,
    this.engineHours,
  });

  bool get hasMarinaAccess => marinaId != null;

  Boat copyWith({
    String? name,
    String? model,
    BoatType? type,
    int? year,
    double? length,
    String? marinaId,
    bool clearMarinaId = false,
    double? engineHours,
  }) {
    return Boat(
      id: id,
      name: name ?? this.name,
      model: model ?? this.model,
      type: type ?? this.type,
      year: year ?? this.year,
      length: length ?? this.length,
      marinaId: clearMarinaId ? null : (marinaId ?? this.marinaId),
      engineHours: engineHours ?? this.engineHours,
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
      marinaId: json['marinaId'] as String?,
      engineHours: (json['engineHours'] as num?)?.toDouble(),
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
      'marinaId': marinaId,
      'engineHours': engineHours,
    };
  }
}
