import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat.dart';
import '../../models/service_price_item.dart';
import '../../viewmodels/estai_session_viewmodel.dart';
import '../../viewmodels/service_order_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/marina_background.dart';
import 'service_order_details_form_screen.dart';
import 'widgets/price_item_list_tile.dart';

class ServicePriceItemListScreen extends StatefulWidget {
  final Boat boat;

  const ServicePriceItemListScreen({super.key, required this.boat});

  @override
  State<ServicePriceItemListScreen> createState() =>
      _ServicePriceItemListScreenState();
}

class _ServicePriceItemListScreenState extends State<ServicePriceItemListScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'ServicePriceItemListScreen';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceOrderViewModel>().loadPriceItems(widget.boat.id);
    });
  }

  Future<void> _selectPriceItem(
    BuildContext context,
    ServicePriceItem priceItem,
  ) async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ServiceOrderDetailsFormScreen(
          boat: widget.boat,
          priceItem: priceItem,
        ),
      ),
    );
    if (created == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
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
        title: Text(l10n.selectService),
        backgroundColor: hasBackground
            ? Colors.transparent
            : Colors.black.withAlpha(200),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: MarinaBackground(
        backgroundFile: backgroundFile,
        child: Consumer<ServiceOrderViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoadingPriceItems) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (viewModel.priceItemsErrorMessage != null) {
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
                      l10n.loadPriceItemsError,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => viewModel.loadPriceItems(widget.boat.id),
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

            if (viewModel.priceItems.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.emptyServiceCatalog,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(16, topInset + 16, 16, 16),
              itemCount: viewModel.priceItems.length,
              itemBuilder: (context, index) {
                final priceItem = viewModel.priceItems[index];
                return PriceItemListTile(
                  priceItem: priceItem,
                  onTap: () => _selectPriceItem(context, priceItem),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
