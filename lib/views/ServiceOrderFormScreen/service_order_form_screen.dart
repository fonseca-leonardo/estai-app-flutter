import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat.dart';
import '../../viewmodels/boat_viewmodel.dart';
import '../../viewmodels/estai_session_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/marina_background.dart';
import 'service_price_item_list_screen.dart';
import 'widgets/boat_list_tile.dart';
import 'widgets/no_marina_boats_placeholder.dart';

class ServiceOrderFormScreen extends StatefulWidget {
  const ServiceOrderFormScreen({super.key});

  @override
  State<ServiceOrderFormScreen> createState() => _ServiceOrderFormScreenState();
}

class _ServiceOrderFormScreenState extends State<ServiceOrderFormScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'ServiceOrderFormScreen';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backgroundFile = context.select<EstaiSessionViewModel, File?>(
      (vm) => vm.backgroundFile,
    );
    final hasBackground = backgroundFile != null;
    final topInset = hasBackground
        ? MediaQuery.paddingOf(context).top + kToolbarHeight
        : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: hasBackground,
      appBar: AppBar(
        title: Text(l10n.selectBoat),
        backgroundColor: hasBackground
            ? Colors.transparent
            : Colors.black.withAlpha(200),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: MarinaBackground(
        backgroundFile: backgroundFile,
        child: Consumer<BoatViewModel>(
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

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(16, topInset + 16, 16, 16),
              itemCount: marinaBoats.length,
              itemBuilder: (context, index) {
                final boat = marinaBoats[index];
                return BoatListTile(boat: boat, onTap: () => _selectBoat(boat));
              },
            );
          },
        ),
      ),
    );
  }
}
