import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/checklist.dart';
import '../../theme/app_spacing.dart';
import '../../viewmodels/checklist_run_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/ui/app_dialog.dart';
import '../../widgets/ui/app_scaffold.dart';
import '../../widgets/ui/glass_bar_background.dart';
import '../../widgets/ui/glass_card.dart';
import '../../widgets/ui/section_label.dart';
import 'widgets/checklist_progress_header.dart';
import 'widgets/checklist_run_item_tile.dart';

/// De onde o checklist foi aberto; muda os botões do rodapé.
enum ChecklistRunMode { manual, beforeNavigation, afterNavigation }

/// Marca os itens de um ou mais checklists. Nada é salvo: fechar zera.
///
/// Em [ChecklistRunMode.beforeNavigation], volta `true` para iniciar a
/// navegação; voltar sem escolher cancela o início.
class ChecklistRunScreen extends StatefulWidget {
  final List<Checklist> checklists;
  final ChecklistRunMode mode;

  const ChecklistRunScreen({
    super.key,
    required this.checklists,
    this.mode = ChecklistRunMode.manual,
  });

  static Future<bool> open(
    BuildContext context, {
    required List<Checklist> checklists,
    ChecklistRunMode mode = ChecklistRunMode.manual,
  }) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChecklistRunScreen(checklists: checklists, mode: mode),
      ),
    );
    return result ?? false;
  }

  @override
  State<ChecklistRunScreen> createState() => _ChecklistRunScreenState();
}

class _ChecklistRunScreenState extends State<ChecklistRunScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'ChecklistRunScreen';

  late final ChecklistRunViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChecklistRunViewModel(checklists: widget.checklists);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  String _title(AppLocalizations l10n) {
    switch (widget.mode) {
      case ChecklistRunMode.beforeNavigation:
        return l10n.checklistRunBeforeTitle;
      case ChecklistRunMode.afterNavigation:
        return l10n.checklistRunAfterTitle;
      case ChecklistRunMode.manual:
        return widget.checklists.length == 1
            ? widget.checklists.single.name
            : l10n.checklistsTitle;
    }
  }

  Future<void> _startNavigation() async {
    final l10n = AppLocalizations.of(context)!;
    final missing = _viewModel.uncheckedCount;
    if (missing > 0) {
      final confirmed = await AppDialog.confirm(
        context,
        title: l10n.checklistMissingItemsTitle,
        message: l10n.checklistMissingItemsMessage(missing),
        confirmLabel: l10n.checklistStartNavigation,
      );
      if (!confirmed || !mounted) return;
    }
    Navigator.of(context).pop(true);
  }

  void _finish() => Navigator.of(context).pop(true);

  Widget _footer(AppLocalizations l10n) {
    final isBefore = widget.mode == ChecklistRunMode.beforeNavigation;
    final primaryStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return GlassBarBackground(
      edge: AxisDirection.up,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: isBefore ? _startNavigation : _finish,
                style: primaryStyle,
                child: Text(
                  isBefore ? l10n.checklistStartNavigation : l10n.checklistDone,
                ),
              ),
              if (isBefore)
                TextButton(
                  onPressed: _finish,
                  child: Text(
                    l10n.checklistSkip,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showSectionNames = widget.checklists.length > 1;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<ChecklistRunViewModel>(
        builder: (context, viewModel, child) {
          return AppScaffold(
            appBar: AppBar(
              title: Text(_title(l10n)),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              flexibleSpace: const GlassBarBackground(),
              actions: [
                if (viewModel.checkedCount > 0)
                  TextButton(
                    onPressed: viewModel.reset,
                    child: Text(
                      l10n.checklistUncheckAll,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ChecklistProgressHeader(
                        checked: viewModel.checkedCount,
                        total: viewModel.totalCount,
                      ),
                      for (final checklist in viewModel.checklists) ...[
                        if (showSectionNames) SectionLabel(checklist.name),
                        GlassCard(
                          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          child: Column(
                            children: [
                              for (final item in checklist.items)
                                ChecklistRunItemTile(
                                  text: item.text,
                                  checked: viewModel.isChecked(item.id),
                                  onToggle: () => viewModel.toggle(item.id),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _footer(l10n),
              ],
            ),
          );
        },
      ),
    );
  }
}
