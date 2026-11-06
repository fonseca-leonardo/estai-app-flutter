import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../models/maintenance.dart';
import '../../utils/engine_hours_format.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../MaintenanceFormScreen/widgets/delete_maintenance_dialog.dart';
import '../MarinaHomeScreen/widgets/marina_section_title.dart';
import '../RampBookingScreen/widgets/summary_row.dart';
import 'widgets/details_section_card.dart';
import 'widgets/maintenance_details_header.dart';

/// Manutenção concluída, somente leitura: o que foi feito, quando, horímetro
/// e custo. Volta `true` se o usuário pediu para excluir; quem abriu a tela
/// faz a exclusão.
class MaintenanceDetailsScreen extends StatefulWidget {
  final Maintenance maintenance;

  const MaintenanceDetailsScreen({super.key, required this.maintenance});

  @override
  State<MaintenanceDetailsScreen> createState() =>
      _MaintenanceDetailsScreenState();
}

class _MaintenanceDetailsScreenState extends State<MaintenanceDetailsScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'MaintenanceDetailsScreen';

  Future<void> _delete() async {
    final navigator = Navigator.of(context);
    final confirmed = await showDeleteMaintenanceDialog(context);
    if (confirmed) navigator.pop(true);
  }

  String? _text(String? value) =>
      value == null || value.trim().isEmpty ? null : value.trim();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final maintenance = widget.maintenance;
    final notInformed = l10n.maintenanceDetailsNotInformed;

    final engineHours = maintenance.completedEngineHours;
    final cost = maintenance.cost;
    final notes = _text(maintenance.notes);
    final provider = _text(maintenance.provider);
    final description = _text(maintenance.description);
    final dueDate = maintenance.dueDate;
    final dueEngineHours = maintenance.dueEngineHours;
    final recurrenceMonths = maintenance.recurrenceMonths;
    final recurrenceHours = maintenance.recurrenceHours;

    final originalDue = [
      if (dueDate != null) DateFormat.yMMMd(locale).format(dueDate.toLocal()),
      if (dueEngineHours != null)
        l10n.maintenanceDueAtHours(
          EngineHoursFormat.format(dueEngineHours, locale),
        ),
    ];
    final recurrence = [
      if (recurrenceMonths != null)
        l10n.maintenanceRecurrenceEveryMonths(recurrenceMonths),
      if (recurrenceHours != null)
        l10n.maintenanceRecurrenceEveryHours(
          EngineHoursFormat.format(recurrenceHours, locale),
        ),
    ];

    final detailRows = [
      if (provider != null)
        SummaryRow(
          icon: Icons.storefront_outlined,
          label: l10n.maintenanceDetailsProvider,
          value: provider,
        ),
      if (description != null)
        SummaryRow(
          icon: Icons.notes_outlined,
          label: l10n.maintenanceDetailsDescription,
          value: description,
        ),
      if (originalDue.isNotEmpty)
        SummaryRow(
          icon: Icons.event_outlined,
          label: l10n.maintenanceDetailsOriginalDue,
          value: originalDue.join(' · '),
        ),
      if (recurrence.isNotEmpty)
        SummaryRow(
          icon: Icons.repeat,
          label: l10n.maintenanceDetailsRecurrence,
          value: recurrence.join(' · '),
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.maintenanceDetailsTitle),
        backgroundColor: Colors.black.withValues(alpha: 0.78),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: l10n.deleteMaintenance,
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          MaintenanceDetailsHeader(maintenance: maintenance),
          const SizedBox(height: 28),
          MarinaSectionTitle(title: l10n.maintenanceCompletionSection),
          DetailsSectionCard(
            rows: [
              SummaryRow(
                icon: Icons.speed_outlined,
                label: l10n.maintenanceDetailsEngineHours,
                value: engineHours != null
                    ? l10n.engineHoursValue(
                        EngineHoursFormat.format(engineHours, locale),
                      )
                    : notInformed,
              ),
              SummaryRow(
                icon: Icons.payments_outlined,
                label: l10n.maintenanceDetailsCost,
                value: cost != null
                    ? NumberFormat.simpleCurrency(locale: locale).format(cost)
                    : notInformed,
              ),
              if (notes != null)
                SummaryRow(
                  icon: Icons.sticky_note_2_outlined,
                  label: l10n.maintenanceDetailsNotes,
                  value: notes,
                ),
            ],
          ),
          if (detailRows.isNotEmpty) ...[
            const SizedBox(height: 28),
            MarinaSectionTitle(title: l10n.maintenanceDetailsInfoSection),
            DetailsSectionCard(rows: detailRows),
          ],
        ],
      ),
    );
  }
}
