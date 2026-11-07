import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/checklist.dart';
import '../../models/checklist_defaults.dart';
import '../../models/checklist_trigger.dart';
import '../../viewmodels/checklists_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/ui/app_scaffold.dart';
import '../../widgets/ui/empty_state.dart';
import '../../widgets/ui/glass_bar_background.dart';
import '../../widgets/ui/glass_extended_fab.dart';
import '../../widgets/ui/section_label.dart';
import '../ChecklistFormScreen/checklist_form_screen.dart';
import '../ChecklistRunScreen/checklist_run_screen.dart';
import 'widgets/checklist_card.dart';

/// Checklists do aparelho, agrupados por quando aparecem.
class ChecklistsScreen extends StatefulWidget {
  const ChecklistsScreen({super.key});

  @override
  State<ChecklistsScreen> createState() => _ChecklistsScreenState();
}

class _ChecklistsScreenState extends State<ChecklistsScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'ChecklistsScreen';

  final _viewModel = ChecklistsViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      _viewModel.load(defaults: () => ChecklistDefaults.build(l10n));
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _openForm([Checklist? checklist]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChecklistFormScreen(checklist: checklist),
      ),
    );
    if (saved == true) _viewModel.load();
  }

  Future<void> _run(Checklist checklist) {
    return ChecklistRunScreen.open(context, checklists: [checklist]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: AppBar(
        title: Text(l10n.checklistsTitle),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: const GlassBarBackground(),
      ),
      floatingActionButton: GlassExtendedFab(
        heroTag: 'checklistsNew',
        icon: Icons.add,
        label: l10n.checklistNew,
        onPressed: _openForm,
      ),
      body: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<ChecklistsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading && viewModel.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                if (viewModel.isEmpty) ...[
                  const SizedBox(height: 48),
                  EmptyState(
                    icon: Icons.checklist_rounded,
                    message: l10n.checklistsEmpty,
                    bordered: false,
                  ),
                ],
                for (final trigger in ChecklistTrigger.values)
                  if (viewModel.byTrigger(trigger).isNotEmpty) ...[
                    SectionLabel(trigger.label(l10n)),
                    for (final checklist in viewModel.byTrigger(trigger))
                      ChecklistCard(
                        checklist: checklist,
                        onRun: () => _run(checklist),
                        onEdit: () => _openForm(checklist),
                      ),
                    const SizedBox(height: 12),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }
}
