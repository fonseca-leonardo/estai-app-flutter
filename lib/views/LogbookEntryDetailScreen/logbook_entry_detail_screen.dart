import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/logbook_entry.dart';
import '../../utils/coordinate_formatter.dart';
import '../../utils/engine_hours_format.dart';
import '../../utils/trip_format.dart';
import '../../viewmodels/logbook_entry_detail_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../LogbookEntryFormScreen/logbook_entry_form_screen.dart';
import '../MaintenanceDetailsScreen/widgets/details_section_card.dart';
import '../MarinaHomeScreen/widgets/marina_section_title.dart';
import '../RampBookingScreen/widgets/summary_row.dart';
import 'widgets/delete_logbook_entry_dialog.dart';
import 'widgets/logbook_entry_header.dart';
import 'widgets/expandable_trip_track_map.dart';
import 'widgets/trip_metric_tile.dart';
import 'widgets/trip_metrics_grid.dart';

/// Detalhe de uma entrada do diário de bordo. Numa viagem mostra o trajeto
/// no mapa e as métricas. Volta `true` se a entrada foi editada ou excluída.
class LogbookEntryDetailScreen extends StatefulWidget {
  final LogbookEntry entry;

  const LogbookEntryDetailScreen({super.key, required this.entry});

  @override
  State<LogbookEntryDetailScreen> createState() =>
      _LogbookEntryDetailScreenState();
}

class _LogbookEntryDetailScreenState extends State<LogbookEntryDetailScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'LogbookEntryDetailScreen';

  late final LogbookEntryDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LogbookEntryDetailViewModel(entry: widget.entry)..loadTrack();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _edit() async {
    final updated = await Navigator.of(context).push<LogbookEntry>(
      MaterialPageRoute(
        builder: (_) => LogbookEntryFormScreen(
          boatId: _viewModel.entry.boatId,
          entry: _viewModel.entry,
        ),
      ),
    );
    if (updated != null) _viewModel.update(updated);
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmed = await showDeleteLogbookEntryDialog(context);
    if (!confirmed) return;

    final success = await _viewModel.delete();
    if (!mounted) return;
    if (success) {
      navigator.pop(true);
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.deleteLogbookEntryError)),
      );
    }
  }

  List<Widget> _tripRows(
    AppLocalizations l10n,
    LogbookEntry entry,
    String locale,
  ) {
    final minutes = entry.durationMinutes;
    final distance = entry.distanceNm;
    final avgSpeed = entry.avgSpeedKn;
    final maxSpeed = entry.maxSpeedKn;
    final engineHours = entry.engineHoursEnd;
    final passengers = entry.passengers;
    return [
      if (minutes != null)
        TripMetricTile(
          icon: Icons.timer_outlined,
          label: l10n.logbookDetailsDuration,
          value: TripFormat.duration(l10n, minutes),
        ),
      if (distance != null)
        TripMetricTile(
          icon: Icons.straighten,
          label: l10n.logbookDetailsDistance,
          value: TripFormat.distance(l10n, distance, locale),
        ),
      if (avgSpeed != null)
        TripMetricTile(
          icon: Icons.speed_outlined,
          label: l10n.logbookDetailsAvgSpeed,
          value: TripFormat.speed(l10n, avgSpeed, locale),
        ),
      if (maxSpeed != null)
        TripMetricTile(
          icon: Icons.bolt_outlined,
          label: l10n.logbookDetailsMaxSpeed,
          value: TripFormat.speed(l10n, maxSpeed, locale),
        ),
      if (engineHours != null)
        TripMetricTile(
          icon: Icons.settings_outlined,
          label: l10n.logbookDetailsEngineHoursEnd,
          value: l10n.engineHoursValue(
            EngineHoursFormat.format(engineHours, locale),
          ),
        ),
      if (passengers != null)
        TripMetricTile(
          icon: Icons.people_outline,
          label: l10n.logbookDetailsPassengers,
          value: passengers.toString(),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<LogbookEntryDetailViewModel>(
        builder: (context, viewModel, child) {
          final entry = viewModel.entry;
          final position = entry.isTrip ? null : entry.startPoint;
          final notes = entry.notes?.trim() ?? '';
          final tripRows = entry.isTrip
              ? _tripRows(l10n, entry, locale)
              : const <Widget>[];

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) Navigator.of(context).pop(viewModel.changed);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(entry.type.label(l10n)),
                backgroundColor: Colors.black.withValues(alpha: 0.78),
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(
                    tooltip: l10n.logbookEditEntry,
                    onPressed: _edit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: l10n.deleteLogbookEntry,
                    onPressed: viewModel.isDeleting ? null : _delete,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
              backgroundColor: Colors.black,
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  LogbookEntryHeader(entry: entry),
                  if (entry.isTrip && entry.trackPoints.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ExpandableTripTrackMap(track: entry.trackPoints),
                  ],
                  if (position != null) ...[
                    const SizedBox(height: 16),
                    ExpandableTripTrackMap(singlePoint: position),
                  ],
                  if (tripRows.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    MarinaSectionTitle(title: l10n.logbookDetailsTripSection),
                    TripMetricsGrid(children: tripRows),
                  ],
                  if (position != null || notes.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    MarinaSectionTitle(title: l10n.logbookDetailsInfoSection),
                    DetailsSectionCard(
                      rows: [
                        if (position != null)
                          SummaryRow(
                            icon: Icons.place_outlined,
                            label: l10n.logbookDetailsPosition,
                            value: CoordinateFormatter.formatLatitude(
                              position.latitude,
                            ),
                            detail: CoordinateFormatter.formatLongitude(
                              position.longitude,
                            ),
                          ),
                        if (notes.isNotEmpty)
                          SummaryRow(
                            icon: Icons.notes_outlined,
                            label: l10n.logbookDetailsNotes,
                            value: notes,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
