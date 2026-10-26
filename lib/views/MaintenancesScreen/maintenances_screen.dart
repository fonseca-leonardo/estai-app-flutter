import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/maintenance.dart';
import '../../models/maintenance_status.dart';
import '../../viewmodels/maintenance_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../MaintenanceDetailsScreen/maintenance_details_screen.dart';
import '../MaintenanceFormScreen/maintenance_form_screen.dart';
import 'widgets/complete_maintenance_sheet.dart';
import 'widgets/maintenances_tab.dart';

/// Manutenções de uma embarcação, em abas: próximas e histórico.
///
/// Também é o destino do toque no push de lembrete; [highlightedId] destaca
/// a manutenção que gerou o aviso.
class MaintenancesScreen extends StatefulWidget {
  final String boatId;
  final String? boatName;
  final double? currentEngineHours;
  final String? highlightedId;

  const MaintenancesScreen({
    super.key,
    required this.boatId,
    this.boatName,
    this.currentEngineHours,
    this.highlightedId,
  });

  @override
  State<MaintenancesScreen> createState() => _MaintenancesScreenState();
}

class _MaintenancesScreenState extends State<MaintenancesScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'MaintenancesScreen';

  late final MaintenanceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MaintenanceViewModel(boatId: widget.boatId);
    WidgetsBinding.instance.addPostFrameCallback((_) => _viewModel.loadAll());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _openForm([Maintenance? maintenance]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => MaintenanceFormScreen(
          boatId: widget.boatId,
          maintenance: maintenance,
          currentEngineHours: widget.currentEngineHours,
        ),
      ),
    );
    if (saved == true) _viewModel.loadAll();
  }

  /// Concluída não se edita mais: abre os detalhes, de onde só dá para
  /// excluir.
  void _open(Maintenance maintenance) {
    if (maintenance.status == MaintenanceStatus.done) {
      _openDetails(maintenance);
    } else {
      _openForm(maintenance);
    }
  }

  Future<void> _openDetails(Maintenance maintenance) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final delete = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => MaintenanceDetailsScreen(maintenance: maintenance),
      ),
    );
    if (delete != true) return;

    final success = await _viewModel.delete(maintenance.id);
    if (!success && mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.deleteMaintenanceError)),
      );
    }
  }

  Future<void> _complete(Maintenance maintenance) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final result = await showCompleteMaintenanceSheet(
      context: context,
      maintenance: maintenance,
      currentEngineHours: widget.currentEngineHours,
    );
    if (result == null) return;

    final success = await _viewModel.complete(
      id: maintenance.id,
      completedAt: result.completedAt,
      engineHours: result.engineHours,
      cost: result.cost,
      notes: result.notes,
    );
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? l10n.maintenanceCompleted : l10n.completeMaintenanceError,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const listPadding = EdgeInsets.fromLTRB(16, 16, 16, 96);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.maintenancesTitle),
              if (widget.boatName != null)
                Text(
                  widget.boatName!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
            ],
          ),
          backgroundColor: Colors.black.withAlpha(200),
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
            dividerColor: Colors.white.withValues(alpha: 0.08),
            tabs: [
              Tab(text: l10n.maintenanceTabUpcoming),
              Tab(text: l10n.maintenanceTabHistory),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openForm,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          icon: const Icon(Icons.add),
          label: Text(l10n.maintenanceNew),
        ),
        body: ChangeNotifierProvider.value(
          value: _viewModel,
          child: Consumer<MaintenanceViewModel>(
            builder: (context, viewModel, child) {
              return TabBarView(
                children: [
                  MaintenancesTab(
                    maintenances: viewModel.upcoming,
                    isLoading: viewModel.isLoadingUpcoming,
                    errorMessage: viewModel.upcomingErrorMessage,
                    emptyMessage: l10n.noUpcomingMaintenances,
                    currentEngineHours: widget.currentEngineHours,
                    highlightedId: widget.highlightedId,
                    onRefresh: viewModel.loadUpcoming,
                    onOpen: _open,
                    onComplete: _complete,
                    padding: listPadding,
                  ),
                  MaintenancesTab(
                    maintenances: viewModel.history,
                    isLoading: viewModel.isLoadingHistory,
                    errorMessage: viewModel.historyErrorMessage,
                    emptyMessage: l10n.noMaintenancesHistory,
                    currentEngineHours: widget.currentEngineHours,
                    highlightedId: widget.highlightedId,
                    onRefresh: viewModel.loadHistory,
                    onOpen: _open,
                    padding: listPadding,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
