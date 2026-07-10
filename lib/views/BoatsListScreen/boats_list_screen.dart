import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/boat_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../BoatFormScreen/boat_form_screen.dart';
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

  Future<void> _deleteBoat(String id) async {
    final viewModel = context.read<BoatViewModel>();
    final success = await viewModel.removeBoat(id);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.deleteBoatError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myBoats),
        backgroundColor: Colors.black.withAlpha(200),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Consumer<BoatViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.boats.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loadBoatsError,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => viewModel.loadBoats(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            );
          }

          if (viewModel.boats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_boat_outlined,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noBoatsFound,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.loadBoats,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.boats.length,
              itemBuilder: (context, index) {
                final boat = viewModel.boats[index];
                return BoatCard(
                  boat: boat,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BoatFormScreen(boat: boat),
                    ),
                  ),
                  onDelete: () => _deleteBoat(boat.id),
                );
              },
            ),
          );
        },
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
}
