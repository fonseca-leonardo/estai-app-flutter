import 'dart:convert';
import '../models/boat_reminder.dart';
import '../models/boat_reminder_status.dart';
import '../models/reminder_settings.dart';
import 'estai_api_client.dart';

class BoatReminderListResult {
  final List<BoatReminder> items;
  final int total;
  final int page;
  final int limit;

  BoatReminderListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });
}

class MarkReminderDoneResult {
  final BoatReminder reminder;

  /// Próximo lembrete criado pelo backend quando é recorrente.
  final BoatReminder? next;

  MarkReminderDoneResult({required this.reminder, this.next});
}

/// Campos editáveis de um lembrete, usados para criar e atualizar.
class BoatReminderInput {
  final String title;
  final String? notes;
  final DateTime dueDate;
  final int? recurrenceMonths;
  final ReminderSettings reminder;

  BoatReminderInput({
    required this.title,
    this.notes,
    required this.dueDate,
    this.recurrenceMonths,
    required this.reminder,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'notes': notes,
      'dueDate': dueDate.toUtc().toIso8601String(),
      'recurrenceMonths': recurrenceMonths,
      'reminder': reminder.toJson(),
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

/// Consome os endpoints de lembretes avulsos (`/boats/{id}/reminders`,
/// `/reminders/{id}`) da API do Estai.
class BoatReminderService {
  final EstaiApiClient _apiClient;

  BoatReminderService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  Map<String, dynamic> _readData(String body) {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    final data = jsonData['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw ApiException('Invalid response: data field is null');
    }
    return data;
  }

  /// Pendentes vêm pela data (mais próxima primeiro); feitos, do mais
  /// recente para o mais antigo.
  Future<BoatReminderListResult> getReminders({
    required String boatId,
    required BoatReminderStatus status,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _apiClient.get(
        '/boats/$boatId/reminders',
        queryParameters: {
          'page': page,
          'limit': limit,
          'status': status.apiValue,
        },
      );

      if (response.statusCode == 200) {
        final data = _readData(response.body);
        final items = (data['items'] as List<dynamic>)
            .map((item) => BoatReminder.fromJson(item as Map<String, dynamic>))
            .toList();

        return BoatReminderListResult(
          items: items,
          total: data['total'] as int,
          page: data['page'] as int,
          limit: data['limit'] as int,
        );
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load reminders: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading reminders: $e');
    }
  }

  Future<BoatReminder> createReminder({
    required String boatId,
    required BoatReminderInput input,
  }) async {
    try {
      final response = await _apiClient.post(
        '/boats/$boatId/reminders',
        body: input.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return BoatReminder.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to create reminder: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error creating reminder: $e');
    }
  }

  Future<BoatReminder> updateReminder({
    required String id,
    required BoatReminderInput input,
  }) async {
    try {
      final response = await _apiClient.put(
        '/reminders/$id',
        body: input.toJson(),
      );

      if (response.statusCode == 200) {
        return BoatReminder.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to update reminder: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error updating reminder: $e');
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      final response = await _apiClient.delete('/reminders/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to delete reminder: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error deleting reminder: $e');
    }
  }

  Future<MarkReminderDoneResult> markDone({
    required String id,
    required DateTime completedAt,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/reminders/$id/done',
        body: {'completedAt': completedAt.toUtc().toIso8601String()},
      );

      if (response.statusCode == 200) {
        final data = _readData(response.body);
        final next = data['next'] as Map<String, dynamic>?;
        return MarkReminderDoneResult(
          reminder: BoatReminder.fromJson(
            data['reminder'] as Map<String, dynamic>,
          ),
          next: next != null ? BoatReminder.fromJson(next) : null,
        );
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to mark reminder as done: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error marking reminder as done: $e');
    }
  }
}
