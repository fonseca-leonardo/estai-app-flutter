import '../../widgets/ui/app_scaffold.dart';
import '../../widgets/ui/empty_state.dart';
import '../../widgets/ui/error_state.dart';
import '../../widgets/ui/skeleton_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/boat_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../BoatFormScreen/boat_form_screen.dart';
import '../BoatJournalScreen/boat_journal_screen.dart';
import 'widgets/boat_card.dart';

class BoatsListScreen extends StatefulWidget {
  const BoatsListScreen({super.key});

  @override
  State<BoatsListScreen> createState() => _BoatsListScreenState();
}

class _BoatsListScreenState extends State<BoatsListScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'BoatsListScreen';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BoatViewModel>().loadBoats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: AppBar(
        title: Text(l10n.myBoats),
        backgroundColor: Colors.black.withValues(alpha: 0.78),
        foregroundColor: Colors.white,
      ),
      body: Consumer<BoatViewModel>(
        builder: (context, viewModel, child) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(
            key: ValueKey(
              viewModel.isLoading && viewModel.boats.isEmpty
                  ? 'loading'
                  : viewModel.errorMessage != null
                  ? 'error'
                  : viewModel.boats.isEmpty
                  ? 'empty'
                  : 'list',
            ),
            child: _buildBody(context, viewModel, l10n),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        tooltip: l10n.addBoat,
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const BoatFormScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BoatViewModel viewModel,
    AppLocalizations l10n,
  ) {
    if (viewModel.isLoading && viewModel.boats.isEmpty) {
      return const SkeletonList(itemHeight: 92);
    }

    if (viewModel.errorMessage != null) {
      return ErrorState(
        message: l10n.loadBoatsError,
        onRetry: viewModel.loadBoats,
      );
    }

    if (viewModel.boats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: EmptyState(
            icon: Icons.directions_boat_outlined,
            message: l10n.noBoatsFound,
            bordered: false,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadBoats,
      backgroundColor: Colors.black,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.boats.length,
        itemBuilder: (context, index) {
          final boat = viewModel.boats[index];
          return BoatCard(
            boat: boat,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => BoatJournalScreen(boat: boat)),
            ),
          );
        },
      ),
    );
  }
}
