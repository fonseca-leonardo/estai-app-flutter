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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.boats.length,
            itemBuilder: (context, index) {
              final boat = viewModel.boats[index];
              return BoatCard(
                boat: boat,
                onDelete: () => viewModel.removeBoat(boat.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        tooltip: l10n.addBoat,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BoatFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
