import 'dart:convert';
import '../models/ramp.dart';
import '../models/ramp_schedule.dart';
import '../models/ramp_schedule_status.dart';
import '../models/ramp_schedule_type.dart';
import '../models/ramp_slot.dart';
import 'estai_api_client.dart';

class RampScheduleListResult {
  final List<RampSchedule> items;
  final int total;
  final int page;
  final int limit;

  RampScheduleListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });
}

class CreateRampScheduleResult {
  final RampSchedule schedule;
  final RampSchedule? returnSchedule;

  CreateRampScheduleResult({required this.schedule, this.returnSchedule});
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

/// Consome os endpoints de agenda de rampa (`/ramp-schedules`) da API do
/// Estai.
class RampScheduleService {
  final EstaiApiClient _apiClient;

  RampScheduleService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  Map<String, dynamic> _readData(String body) {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    final data = jsonData['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw ApiException('Invalid response: data field is null');
    }
    return data;
  }

  Future<List<Ramp>> getRamps() async {
    try {
      final response = await _apiClient.get('/ramp-schedules/ramps');

      if (response.statusCode == 200) {
        final data = _readData(response.body);
        return (data['items'] as List<dynamic>)
            .map((item) => Ramp.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load ramps: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading ramps: $e');
    }
  }

  /// [from] e [to] são dias no relógio da marina (ver `MarinaTime`).
  Future<RampAvailability> getAvailability({
    required String rampId,
    required String from,
    required String to,
  }) async {
    try {
      final response = await _apiClient.get(
        '/ramp-schedules/ramps/$rampId/availability',
        queryParameters: {'from': from, 'to': to},
      );

      if (response.statusCode == 200) {
        return RampAvailability.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load ramp availability: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading ramp availability: $e');
    }
  }

  Future<CreateRampScheduleResult> createSchedule({
    required String rampId,
    required String boatId,
    required RampScheduleType type,
    required DateTime scheduledAt,
    DateTime? returnAt,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.post(
        '/ramp-schedules',
        body: {
          'rampId': rampId,
          'boatId': boatId,
          'type': type.apiValue,
          'scheduledAt': scheduledAt.toUtc().toIso8601String(),
          if (returnAt != null) 'returnAt': returnAt.toUtc().toIso8601String(),
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = _readData(response.body);
        final returnSchedule = data['returnSchedule'] as Map<String, dynamic>?;
        return CreateRampScheduleResult(
          schedule: RampSchedule.fromJson(
            data['schedule'] as Map<String, dynamic>,
          ),
          returnSchedule: returnSchedule != null
              ? RampSchedule.fromJson(returnSchedule)
              : null,
        );
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to create ramp schedule: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error creating ramp schedule: $e');
    }
  }

  Future<RampScheduleListResult> getSchedules({
    int page = 1,
    int limit = 50,
    RampScheduleStatus? status,
    String? boatId,
    bool? upcoming,
  }) async {
    try {
      final response = await _apiClient.get(
        '/ramp-schedules',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (status != null) 'status': status.apiValue,
          'boatId': ?boatId,
          if (upcoming != null) 'upcoming': upcoming.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = _readData(response.body);
        final items = (data['items'] as List<dynamic>)
            .map((item) => RampSchedule.fromJson(item as Map<String, dynamic>))
            .toList();

        return RampScheduleListResult(
          items: items,
          total: data['total'] as int,
          page: data['page'] as int,
          limit: data['limit'] as int,
        );
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load ramp schedules: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading ramp schedules: $e');
    }
  }

  Future<RampSchedule> cancelSchedule(String id) async {
    try {
      final response = await _apiClient.patch('/ramp-schedules/$id/cancel');

      if (response.statusCode == 200) {
        return RampSchedule.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to cancel ramp schedule: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error cancelling ramp schedule: $e');
    }
  }
}
