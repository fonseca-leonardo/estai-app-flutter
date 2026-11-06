import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat.dart';
import '../../models/logbook_entry.dart';
import '../../models/maintenance.dart';
import '../../viewmodels/boat_journal_viewmodel.dart';
import '../../viewmodels/boat_viewmodel.dart';
import '../../viewmodels/estai_session_viewmodel.dart';
import '../../viewmodels/trip_log_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../BoatFormScreen/boat_form_screen.dart';
import '../LogbookEntryDetailScreen/logbook_entry_detail_screen.dart';
import '../LogbookScreen/logbook_screen.dart';
import '../MaintenanceFormScreen/maintenance_form_screen.dart';
import '../MaintenancesScreen/maintenances_screen.dart';
import '../MarinaHomeScreen/widgets/marina_section_title.dart';
import 'widgets/delete_boat_dialog.dart';
import 'widgets/journal_boat_menu.dart';
import 'widgets/journal_header_card.dart';
import 'widgets/journal_overdue_alert.dart';
import 'widgets/journal_quick_actions.dart';
import 'widgets/marina_access_card.dart';
import 'widgets/recent_logbook_preview.dart';
import 'widgets/update_engine_hours_sheet.dart';
import 'widgets/upcoming_maintenances_preview.dart';

/// Diário da Embarcação: o hub que acompanha a vida do barco (horímetro e
/// manutenções nesta fase).
class BoatJournalScreen extends StatefulWidget {
  final Boat boat;

  const BoatJournalScreen({super.key, required this.boat});

  @override
  State<BoatJournalScreen> createState() => _BoatJournalScreenState();
}

class _BoatJournalScreenState extends State<BoatJournalScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'BoatJournalScreen';

  late final BoatJournalViewModel _viewModel;
  bool _isUpdatingMarinaAccess = false;

  @override
  void initState() {
    super.initState();
    _viewModel = BoatJournalViewModel(
      boatId: widget.boat.id,
      initialEngineHours: widget.boat.engineHours,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  /// Envia antes as viagens que ficaram na fila sem conexão, para que já
  /// apareçam no resumo.
  Future<void> _refresh() async {
    await context.read<TripLogViewModel>().flushPending();
    await _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _push(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    // Manutenções podem ter sido criadas, concluídas ou excluídas.
    _viewModel.load();
  }

  void _openMaintenances(Boat boat) {
    _push(
      MaintenancesScreen(
        boatId: boat.id,
        boatName: boat.name,
        currentEngineHours: _viewModel.engineHours,
      ),
    );
  }

  void _openLogbook(Boat boat) {
    _push(LogbookScreen(boatId: boat.id, boatName: boat.name));
  }

  void _openLogbookEntry(LogbookEntry entry) {
    _push(LogbookEntryDetailScreen(entry: entry));
  }

  void _openMaintenanceForm([Maintenance? maintenance]) {
    _push(
      MaintenanceFormScreen(
        boatId: widget.boat.id,
        maintenance: maintenance,
        currentEngineHours: _viewModel.engineHours,
      ),
    );
  }

  Future<void> _updateEngineHours() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final hours = await showUpdateEngineHoursSheet(
      context: context,
      currentEngineHours: _viewModel.engineHours,
    );
    if (hours == null) return;

    final success = await _viewModel.updateEngineHours(hours);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? l10n.engineHoursSaved : l10n.engineHoursSaveError,
        ),
      ),
    );
  }

  Future<void> _toggleMarinaAccess(bool access) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final boatViewModel = context.read<BoatViewModel>();

    setState(() => _isUpdatingMarinaAccess = true);
    final success = await boatViewModel.setMarinaAccess(widget.boat.id, access);
    if (!mounted) return;

    setState(() => _isUpdatingMarinaAccess = false);
    if (!success) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.marinaAccessToggleError)),
      );
    }
  }

  void _editBoat(Boat boat) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => BoatFormScreen(boat: boat)));
  }

  Future<void> _deleteBoat() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final boatViewModel = context.read<BoatViewModel>();

    final confirmed = await showDeleteBoatDialog(context);
    if (!confirmed) return;

    final success = await boatViewModel.removeBoat(widget.boat.id);
    if (!mounted) return;
    if (success) {
      navigator.pop();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteBoatError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Reflete edições feitas no cadastro do barco a partir daqui.
    final boat = context.select<BoatViewModel, Boat>(
      (vm) => vm.boats.firstWhere(
        (item) => item.id == widget.boat.id,
        orElse: () => widget.boat,
      ),
    );
    final hasMarina = context.select<EstaiSessionViewModel, bool>(
      (vm) => vm.hasMarina,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.journalTitle),
        backgroundColor: Colors.black.withValues(alpha: 0.78),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          JournalBoatMenu(onEdit: () => _editBoat(boat), onDelete: _deleteBoat),
        ],
      ),
      backgroundColor: Colors.black,
      body: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<BoatJournalViewModel>(
          builder: (context, viewModel, child) {
            final overview = viewModel.overview;
            final overdueCount = overview?.overdueMaintenancesCount ?? 0;

            return RefreshIndicator(
              onRefresh: _refresh,
              color: Colors.black,
              backgroundColor: Colors.white,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  JournalHeaderCard(
                    boat: boat,
                    engineHours: viewModel.engineHours,
                    engineHoursReadAt: overview?.engineHoursReadAt,
                    onUpdateEngineHours: viewModel.isSavingEngineHours
                        ? null
                        : _updateEngineHours,
                  ),
                  if (hasMarina) ...[
                    const SizedBox(height: 12),
                    MarinaAccessCard(
                      value: boat.hasMarinaAccess,
                      isUpdating: _isUpdatingMarinaAccess,
                      onChanged: _toggleMarinaAccess,
                    ),
                  ],
                  if (overdueCount > 0) ...[
                    const SizedBox(height: 16),
                    JournalOverdueAlert(
                      count: overdueCount,
                      onTap: () => _openMaintenances(boat),
                    ),
                  ],
                  const SizedBox(height: 28),
                  MarinaSectionTitle(title: l10n.journalQuickActionsTitle),
                  JournalQuickActions(
                    onNewMaintenance: _openMaintenanceForm,
                    onMaintenances: () => _openMaintenances(boat),
                    onLogbook: () => _openLogbook(boat),
                  ),
                  const SizedBox(height: 32),
                  MarinaSectionTitle(
                    title: l10n.journalUpcomingMaintenancesTitle,
                  ),
                  UpcomingMaintenancesPreview(
                    maintenances: overview?.upcomingMaintenances ?? const [],
                    currentEngineHours: viewModel.engineHours,
                    isLoading: viewModel.isLoading,
                    hasError: viewModel.errorMessage != null,
                    onSeeAll: () => _openMaintenances(boat),
                    onCreate: _openMaintenanceForm,
                    onOpen: _openMaintenanceForm,
                  ),
                  const SizedBox(height: 32),
                  MarinaSectionTitle(title: l10n.journalRecentLogbookTitle),
                  RecentLogbookPreview(
                    entries: overview?.recentLogbookEntries ?? const [],
                    isLoading: viewModel.isLoading,
                    onSeeAll: () => _openLogbook(boat),
                    onOpen: _openLogbookEntry,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
