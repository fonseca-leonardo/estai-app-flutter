import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat_reminder.dart';
import '../../viewmodels/boat_reminders_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/ui/app_scaffold.dart';
import '../BoatReminderFormScreen/boat_reminder_form_screen.dart';
import 'widgets/boat_reminder_done_sheet.dart';
import 'widgets/boat_reminders_tab.dart';
import 'widgets/mark_reminder_done_dialog.dart';

/// Lembretes avulsos de uma embarcação, em abas: pendentes e feitos.
///
/// Também é o destino do toque no push; [highlightedId] destaca o lembrete
/// que gerou o aviso.
class BoatRemindersScreen extends StatefulWidget {
  final String boatId;
  final String? boatName;
  final String? highlightedId;

  const BoatRemindersScreen({
    super.key,
    required this.boatId,
    this.boatName,
    this.highlightedId,
  });

  @override
  State<BoatRemindersScreen> createState() => _BoatRemindersScreenState();
}

class _BoatRemindersScreenState extends State<BoatRemindersScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'BoatRemindersScreen';

  late final BoatRemindersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BoatRemindersViewModel(boatId: widget.boatId);
    WidgetsBinding.instance.addPostFrameCallback((_) => _viewModel.loadAll());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _openForm([BoatReminder? reminder]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            BoatReminderFormScreen(boatId: widget.boatId, reminder: reminder),
      ),
    );
    if (saved == true) _viewModel.loadAll();
  }

  /// Feito não se edita: abre o resumo, de onde só dá para excluir.
  Future<void> _open(BoatReminder reminder) async {
    if (!reminder.isDone) {
      _openForm(reminder);
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final delete = await showBoatReminderDoneSheet(
      context: context,
      reminder: reminder,
    );
    if (!delete) return;

    final success = await _viewModel.delete(reminder.id);
    if (!success && mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.deleteBoatReminderError)),
      );
    }
  }

  Future<void> _markDone(BoatReminder reminder) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showMarkReminderDoneDialog(context, reminder);
    if (!confirmed) return;

    final success = await _viewModel.markDone(reminder.id);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? l10n.boatReminderMarkedDone
              : l10n.markBoatReminderDoneError,
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
      child: AppScaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.boatRemindersTitle),
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
          backgroundColor: Colors.black.withValues(alpha: 0.78),
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
            dividerColor: Colors.white.withValues(alpha: 0.08),
            tabs: [
              Tab(text: l10n.boatReminderTabPending),
              Tab(text: l10n.boatReminderTabDone),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openForm,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          icon: const Icon(Icons.add),
          label: Text(l10n.boatReminderNew),
        ),
        body: ChangeNotifierProvider.value(
          value: _viewModel,
          child: Consumer<BoatRemindersViewModel>(
            builder: (context, viewModel, child) {
              return TabBarView(
                children: [
                  BoatRemindersTab(
                    reminders: viewModel.pending,
                    isLoading: viewModel.isLoadingPending,
                    errorMessage: viewModel.pendingErrorMessage,
                    emptyMessage: l10n.noPendingBoatReminders,
                    highlightedId: widget.highlightedId,
                    onRefresh: viewModel.loadPending,
                    onOpen: _open,
                    onMarkDone: _markDone,
                    padding: listPadding,
                  ),
                  BoatRemindersTab(
                    reminders: viewModel.done,
                    isLoading: viewModel.isLoadingDone,
                    errorMessage: viewModel.doneErrorMessage,
                    emptyMessage: l10n.noDoneBoatReminders,
                    highlightedId: widget.highlightedId,
                    onRefresh: viewModel.loadDone,
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
