import 'package:latlong2/latlong.dart';
import '../utils/polyline_codec.dart';
import 'logbook_entry_type.dart';

/// Entrada do diário de bordo: uma viagem gravada pela navegação ou um
/// registro manual (nota, fundeio, ocorrência, evento).
class LogbookEntry {
  final String id;
  final String boatId;
  final LogbookEntryType type;
  final String title;
  final String? notes;
  final DateTime occurredAt;
  final DateTime? endedAt;
  final double? distanceNm;
  final int? durationMinutes;
  final double? avgSpeedKn;
  final double? maxSpeedKn;
  final LatLng? startPoint;
  final LatLng? endPoint;

  /// Trajeto da viagem como polyline do Google (precisão 5).
  final String? track;
  final double? engineHoursEnd;
  final int? passengers;
  final DateTime createdAt;
  final DateTime updatedAt;

  LogbookEntry({
    required this.id,
    required this.boatId,
    required this.type,
    required this.title,
    this.notes,
    required this.occurredAt,
    this.endedAt,
    this.distanceNm,
    this.durationMinutes,
    this.avgSpeedKn,
    this.maxSpeedKn,
    this.startPoint,
    this.endPoint,
    this.track,
    this.engineHoursEnd,
    this.passengers,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isTrip => type == LogbookEntryType.trip;

  List<LatLng> get trackPoints {
    final encoded = track;
    if (encoded == null || encoded.isEmpty) return const [];
    return PolylineCodec.decode(encoded);
  }

  factory LogbookEntry.fromJson(Map<String, dynamic> json) {
    return LogbookEntry(
      id: json['id'] as String,
      boatId: json['boatId'] as String,
      type: LogbookEntryType.fromApiValue(json['type'] as String),
      title: json['title'] as String,
      notes: json['notes'] as String?,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      endedAt: DateTime.tryParse(json['endedAt'] as String? ?? ''),
      distanceNm: (json['distanceNm'] as num?)?.toDouble(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      avgSpeedKn: (json['avgSpeedKn'] as num?)?.toDouble(),
      maxSpeedKn: (json['maxSpeedKn'] as num?)?.toDouble(),
      startPoint: pointFromJson(json['startPoint']),
      endPoint: pointFromJson(json['endPoint']),
      track: json['track'] as String?,
      engineHoursEnd: (json['engineHoursEnd'] as num?)?.toDouble(),
      passengers: (json['passengers'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// `{lat, lng}` da API.
  static LatLng? pointFromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final lat = value['lat'] as num?;
    final lng = value['lng'] as num?;
    if (lat == null || lng == null) return null;
    return LatLng(lat.toDouble(), lng.toDouble());
  }

  static Map<String, dynamic>? pointToJson(LatLng? point) {
    if (point == null) return null;
    return {'lat': point.latitude, 'lng': point.longitude};
  }
}
