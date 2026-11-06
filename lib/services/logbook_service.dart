import 'dart:convert';
import 'package:latlong2/latlong.dart';
import '../models/logbook_entry.dart';
import '../models/logbook_entry_type.dart';
import 'estai_api_client.dart';

class LogbookListResult {
  final List<LogbookEntry> items;
  final int total;
  final int page;
  final int limit;

  LogbookListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  bool get hasMore => page * limit < total;
}

/// Campos de uma entrada do diário de bordo, usados para criar e atualizar.
/// Também é o que a fila offline guarda ([toJson]/[fromJson]).
class LogbookEntryInput {
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
  final String? track;
  final double? engineHoursEnd;
  final int? passengers;

  LogbookEntryInput({
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
  });

  /// Mantém os dados gravados (trajeto, métricas) e troca só o que o
  /// formulário edita.
  factory LogbookEntryInput.fromEntry(
    LogbookEntry entry, {
    LogbookEntryType? type,
    String? title,
    String? notes,
    DateTime? occurredAt,
    LatLng? startPoint,
    bool clearStartPoint = false,
  }) {
    return LogbookEntryInput(
      type: type ?? entry.type,
      title: title ?? entry.title,
      notes: notes,
      occurredAt: occurredAt ?? entry.occurredAt,
      endedAt: entry.endedAt,
      distanceNm: entry.distanceNm,
      durationMinutes: entry.durationMinutes,
      avgSpeedKn: entry.avgSpeedKn,
      maxSpeedKn: entry.maxSpeedKn,
      startPoint: clearStartPoint ? null : (startPoint ?? entry.startPoint),
      endPoint: entry.endPoint,
      track: entry.track,
      engineHoursEnd: entry.engineHoursEnd,
      passengers: entry.passengers,
    );
  }

  factory LogbookEntryInput.fromJson(Map<String, dynamic> json) {
    return LogbookEntryInput(
      type: LogbookEntryType.fromApiValue(json['type'] as String),
      title: json['title'] as String,
      notes: json['notes'] as String?,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      endedAt: DateTime.tryParse(json['endedAt'] as String? ?? ''),
      distanceNm: (json['distanceNm'] as num?)?.toDouble(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      avgSpeedKn: (json['avgSpeedKn'] as num?)?.toDouble(),
      maxSpeedKn: (json['maxSpeedKn'] as num?)?.toDouble(),
      startPoint: LogbookEntry.pointFromJson(json['startPoint']),
      endPoint: LogbookEntry.pointFromJson(json['endPoint']),
      track: json['track'] as String?,
      engineHoursEnd: (json['engineHoursEnd'] as num?)?.toDouble(),
      passengers: (json['passengers'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.apiValue,
      'title': title,
      'notes': notes,
      'occurredAt': occurredAt.toUtc().toIso8601String(),
      'endedAt': endedAt?.toUtc().toIso8601String(),
      'distanceNm': distanceNm,
      'durationMinutes': durationMinutes,
      'avgSpeedKn': avgSpeedKn,
      'maxSpeedKn': maxSpeedKn,
      'startPoint': LogbookEntry.pointToJson(startPoint),
      'endPoint': LogbookEntry.pointToJson(endPoint),
      'track': track,
      'engineHoursEnd': engineHoursEnd,
      'passengers': passengers,
    };
  }
}

String? _extractErrorMessage(String body) {
  try {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    final message = jsonData['message'];
    if (message is List) return message.join('\n');
    return message as String?;
  } catch (_) {
    return null;
  }
}

/// Consome os endpoints do diário de bordo (`/boats/{id}/logbook`,
/// `/logbook/{id}`) da API do Estai.
class LogbookService {
  final EstaiApiClient _apiClient;

  LogbookService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  Map<String, dynamic> _readData(String body) {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    final data = jsonData['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw ApiException('Invalid response: data field is null');
    }
    return data;
  }

  /// Da entrada mais recente para a mais antiga.
  Future<LogbookListResult> getEntries({
    required String boatId,
    LogbookEntryType? type,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '/boats/$boatId/logbook',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (type != null) 'type': type.apiValue,
        },
      );

      if (response.statusCode == 200) {
        final data = _readData(response.body);
        final items = (data['items'] as List<dynamic>)
            .map((item) => LogbookEntry.fromJson(item as Map<String, dynamic>))
            .toList();

        return LogbookListResult(
          items: items,
          total: data['total'] as int,
          page: data['page'] as int,
          limit: data['limit'] as int,
        );
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load logbook: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading logbook: $e');
    }
  }

  /// Entrada completa, com o trajeto (a listagem não o traz).
  Future<LogbookEntry> getEntry(String id) async {
    try {
      final response = await _apiClient.get('/logbook/$id');

      if (response.statusCode == 200) {
        return LogbookEntry.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load logbook entry: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading logbook entry: $e');
    }
  }

  Future<LogbookEntry> createEntry({
    required String boatId,
    required LogbookEntryInput input,
  }) async {
    try {
      final response = await _apiClient.post(
        '/boats/$boatId/logbook',
        body: input.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return LogbookEntry.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to create logbook entry: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error creating logbook entry: $e');
    }
  }

  Future<LogbookEntry> updateEntry({
    required String id,
    required LogbookEntryInput input,
  }) async {
    try {
      final response = await _apiClient.put(
        '/logbook/$id',
        body: input.toJson(),
      );

      if (response.statusCode == 200) {
        return LogbookEntry.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to update logbook entry: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error updating logbook entry: $e');
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      final response = await _apiClient.delete('/logbook/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to delete logbook entry: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error deleting logbook entry: $e');
    }
  }
}
