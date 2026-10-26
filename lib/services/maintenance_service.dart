import 'dart:convert';
import '../models/maintenance.dart';
import '../models/maintenance_category.dart';
import '../models/reminder_settings.dart';
import 'estai_api_client.dart';

class MaintenanceListResult {
  final List<Maintenance> items;
  final int total;
  final int page;
  final int limit;

  MaintenanceListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });
}

class CompleteMaintenanceResult {
  final Maintenance maintenance;

  /// Próxima ocorrência criada pelo backend quando a manutenção é recorrente.
  final Maintenance? next;

  CompleteMaintenanceResult({required this.maintenance, this.next});
}

/// Dados de uma manutenção que já foi feita: registrar o histórico ou
/// corrigir uma conclusão.
class MaintenanceCompletionInput {
  final DateTime completedAt;
  final double? engineHours;
  final double? cost;
  final String? notes;

  MaintenanceCompletionInput({
    required this.completedAt,
    this.engineHours,
    this.cost,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'completedAt': completedAt.toUtc().toIso8601String(),
      'engineHours': engineHours,
      'cost': cost,
      'notes': notes,
    };
  }
}

/// Campos editáveis de uma manutenção, usados para criar e atualizar.
///
/// Com [completion], a manutenção é gravada já concluída (status `Done`) e
/// o vencimento deixa de ser obrigatório.
class MaintenanceInput {
  final String title;
  final String? description;
  final MaintenanceCategory category;
  final DateTime? dueDate;
  final double? dueEngineHours;
  final int? recurrenceMonths;
  final double? recurrenceHours;
  final String? provider;
  final ReminderSettings reminder;
  final MaintenanceCompletionInput? completion;

  MaintenanceInput({
    required this.title,
    this.description,
    required this.category,
    this.dueDate,
    this.dueEngineHours,
    this.recurrenceMonths,
    this.recurrenceHours,
    this.provider,
    required this.reminder,
    this.completion,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category.apiValue,
      'dueDate': dueDate?.toUtc().toIso8601String(),
      'dueEngineHours': dueEngineHours,
      'recurrenceMonths': recurrenceMonths,
      'recurrenceHours': recurrenceHours,
      'provider': provider,
      'reminder': reminder.toJson(),
      'completion': completion?.toJson(),
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

/// Consome os endpoints de manutenção da embarcação
/// (`/boats/{id}/maintenances`, `/maintenances/{id}`) da API do Estai.
class MaintenanceService {
  final EstaiApiClient _apiClient;

  MaintenanceService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  Map<String, dynamic> _readData(String body) {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    final data = jsonData['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw ApiException('Invalid response: data field is null');
    }
    return data;
  }

  /// [upcoming] `true` traz as pendentes (agendadas e atrasadas) ordenadas
  /// pelo vencimento; `false`, as concluídas da mais recente para a mais
  /// antiga.
  Future<MaintenanceListResult> getMaintenances({
    required String boatId,
    required bool upcoming,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _apiClient.get(
        '/boats/$boatId/maintenances',
        queryParameters: {
          'page': page,
          'limit': limit,
          'upcoming': upcoming.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = _readData(response.body);
        final items = (data['items'] as List<dynamic>)
            .map((item) => Maintenance.fromJson(item as Map<String, dynamic>))
            .toList();

        return MaintenanceListResult(
          items: items,
          total: data['total'] as int,
          page: data['page'] as int,
          limit: data['limit'] as int,
        );
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load maintenances: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading maintenances: $e');
    }
  }

  Future<Maintenance> createMaintenance({
    required String boatId,
    required MaintenanceInput input,
  }) async {
    try {
      final response = await _apiClient.post(
        '/boats/$boatId/maintenances',
        body: input.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Maintenance.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to create maintenance: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error creating maintenance: $e');
    }
  }

  Future<Maintenance> updateMaintenance({
    required String id,
    required MaintenanceInput input,
  }) async {
    try {
      final response = await _apiClient.put(
        '/maintenances/$id',
        body: input.toJson(),
      );

      if (response.statusCode == 200) {
        return Maintenance.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to update maintenance: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error updating maintenance: $e');
    }
  }

  Future<void> deleteMaintenance(String id) async {
    try {
      final response = await _apiClient.delete('/maintenances/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to delete maintenance: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error deleting maintenance: $e');
    }
  }

  Future<CompleteMaintenanceResult> completeMaintenance({
    required String id,
    required DateTime completedAt,
    double? engineHours,
    double? cost,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/maintenances/$id/complete',
        body: {
          'completedAt': completedAt.toUtc().toIso8601String(),
          'engineHours': ?engineHours,
          'cost': ?cost,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );

      if (response.statusCode == 200) {
        final data = _readData(response.body);
        final next = data['next'] as Map<String, dynamic>?;
        return CompleteMaintenanceResult(
          maintenance: Maintenance.fromJson(
            data['maintenance'] as Map<String, dynamic>,
          ),
          next: next != null ? Maintenance.fromJson(next) : null,
        );
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to complete maintenance: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error completing maintenance: $e');
    }
  }
}
