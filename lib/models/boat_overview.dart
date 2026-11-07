import 'boat_reminder.dart';
import 'logbook_entry.dart';
import 'maintenance.dart';

/// Resumo do Diário da Embarcação (`GET /boats/{id}/overview`).
class BoatOverview {
  final String boatId;
  final double? engineHours;
  final DateTime? engineHoursReadAt;
  final int overdueMaintenancesCount;
  final List<Maintenance> upcomingMaintenances;
  final List<LogbookEntry> recentLogbookEntries;
  final List<BoatReminder> upcomingReminders;

  /// Documentos do barco vencidos ou vencendo (≤ 30 dias).
  final int expiringDocumentsCount;

  BoatOverview({
    required this.boatId,
    this.engineHours,
    this.engineHoursReadAt,
    required this.overdueMaintenancesCount,
    required this.upcomingMaintenances,
    required this.recentLogbookEntries,
    this.upcomingReminders = const [],
    this.expiringDocumentsCount = 0,
  });

  BoatOverview copyWith({double? engineHours, DateTime? engineHoursReadAt}) {
    return BoatOverview(
      boatId: boatId,
      engineHours: engineHours ?? this.engineHours,
      engineHoursReadAt: engineHoursReadAt ?? this.engineHoursReadAt,
      overdueMaintenancesCount: overdueMaintenancesCount,
      upcomingMaintenances: upcomingMaintenances,
      recentLogbookEntries: recentLogbookEntries,
      upcomingReminders: upcomingReminders,
      expiringDocumentsCount: expiringDocumentsCount,
    );
  }

  factory BoatOverview.fromJson(Map<String, dynamic> json) {
    return BoatOverview(
      boatId: json['boatId'] as String,
      engineHours: (json['engineHours'] as num?)?.toDouble(),
      engineHoursReadAt: DateTime.tryParse(
        json['engineHoursReadAt'] as String? ?? '',
      ),
      overdueMaintenancesCount:
          (json['overdueMaintenancesCount'] as num?)?.toInt() ?? 0,
      upcomingMaintenances:
          (json['upcomingMaintenances'] as List<dynamic>? ?? [])
              .map((item) => Maintenance.fromJson(item as Map<String, dynamic>))
              .toList(),
      recentLogbookEntries:
          (json['recentLogbookEntries'] as List<dynamic>? ?? [])
              .map(
                (item) => LogbookEntry.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      upcomingReminders: (json['upcomingReminders'] as List<dynamic>? ?? [])
          .map((item) => BoatReminder.fromJson(item as Map<String, dynamic>))
          .toList(),
      expiringDocumentsCount:
          (json['expiringDocumentsCount'] as num?)?.toInt() ?? 0,
    );
  }
}
