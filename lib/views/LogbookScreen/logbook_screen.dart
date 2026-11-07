import '../../widgets/ui/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/logbook_entry.dart';
import '../../viewmodels/logbook_viewmodel.dart';
import '../../viewmodels/trip_log_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../LogbookEntryDetailScreen/logbook_entry_detail_screen.dart';
import '../LogbookEntryFormScreen/logbook_entry_form_screen.dart';
import 'widgets/logbook_entry_card.dart';
import 'widgets/logbook_type_filter.dart';

/// Diário de bordo de uma embarcação: viagens salvas e registros manuais.
class LogbookScreen extends StatefulWidget {
  final String boatId;
  final String? boatName;

  const LogbookScreen({super.key, required this.boatId, this.boatName});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'LogbookScreen';

  late final LogbookViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LogbookViewModel(boatId: widget.boatId);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  /// Envia antes as viagens que ficaram na fila sem conexão.
  Future<void> _refresh() async {
    await context.read<TripLogViewModel>().flushPending();
    await _viewModel.load();
  }

  Future<void> _openNew() async {
    final created = await Navigator.of(context).push<LogbookEntry>(
      MaterialPageRoute(
        builder: (_) => LogbookEntryFormScreen(boatId: widget.boatId),
      ),
    );
    if (created != null) _viewModel.load();
  }

  Future<void> _openEntry(LogbookEntry entry) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => LogbookEntryDetailScreen(entry: entry)),
    );
    if (changed == true) _viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.logbookTitle),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNew,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: Text(l10n.logbookNewEntry),
      ),
      body: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<LogbookViewModel>(
          builder: (context, viewModel, child) {
            final entries = viewModel.entries;
            final String? message = entries.isEmpty && !viewModel.isLoading
                ? (viewModel.errorMessage != null
                      ? l10n.loadLogbookError
                      : l10n.noLogbookEntries)
                : null;

            return Column(
              children: [
                const SizedBox(height: 12),
                LogbookTypeFilter(
                  selected: viewModel.filter,
                  onChanged: viewModel.setFilter,
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: viewModel.isLoading && entries.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : RefreshIndicator(
                          onRefresh: _refresh,
                          color: Colors.black,
                          backgroundColor: Colors.white,
                          child: message != null
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(16),
                                  children: [
                                    const SizedBox(height: 80),
                                    Icon(
                                      Icons.menu_book_outlined,
                                      size: 56,
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      message,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    12,
                                    16,
                                    96,
                                  ),
                                  itemCount:
                                      entries.length +
                                      (viewModel.hasMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index >= entries.length) {
                                      // Chegou ao fim: busca a próxima página
                                      // depois do build (loadMore notifica).
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                            (_) => viewModel.loadMore(),
                                          );
                                      return const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }
                                    final entry = entries[index];
                                    return LogbookEntryCard(
                                      entry: entry,
                                      onTap: () => _openEntry(entry),
                                    );
                                  },
                                ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
