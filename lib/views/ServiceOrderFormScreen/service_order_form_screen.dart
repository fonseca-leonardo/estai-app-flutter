import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat.dart';
import '../../viewmodels/boat_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import 'service_price_item_list_screen.dart';
import 'widgets/boat_list_tile.dart';
import 'widgets/no_marina_boats_placeholder.dart';

class ServiceOrderFormScreen extends StatefulWidget {
  const ServiceOrderFormScreen({super.key});

  @override
  State<ServiceOrderFormScreen> createState() =>
      _ServiceOrderFormScreenState();
}

class _ServiceOrderFormScreenState extends State<ServiceOrderFormScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'ServiceOrderFormScreen';

  bool _autoNavigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boatViewModel = context.read<BoatViewModel>();
      if (boatViewModel.boats.isEmpty) {
        boatViewModel.loadBoats();
      }
    });
  }

  void _selectBoat(Boat boat) {
    Navigator.of(context)
        .push<bool>(
          MaterialPageRoute(
            builder: (_) => ServicePriceItemListScreen(boat: boat),
          ),
        )
        .then((created) {
          if (created == true && mounted) {
            Navigator.of(context).pop(true);
          }
        });
  }

  void _autoSelectBoat(Boat boat) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ServicePriceItemListScreen(boat: boat)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectBoat),
        backgroundColor: Colors.black.withAlpha(200),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Consumer<BoatViewModel>(
        builder: (context, boatViewModel, child) {
          if (boatViewModel.isLoading && boatViewModel.boats.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final marinaBoats = boatViewModel.boats
              .where((boat) => boat.hasMarinaAccess)
              .toList();

          if (marinaBoats.isEmpty) {
            return const NoMarinaBoatsPlaceholder();
          }

          if (marinaBoats.length == 1 && !_autoNavigated) {
            _autoNavigated = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _autoSelectBoat(marinaBoats.first);
            });
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: marinaBoats.length,
            itemBuilder: (context, index) {
              final boat = marinaBoats[index];
              return BoatListTile(
                boat: boat,
                onTap: () => _selectBoat(boat),
              );
            },
          );
        },
      ),
    );
  }
}
