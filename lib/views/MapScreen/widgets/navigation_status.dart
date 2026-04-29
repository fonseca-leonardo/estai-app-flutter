import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/navigation_status_viewmodel.dart';
import '../../../viewmodels/ad_banner_viewmodel.dart';
import '../../../components/navigation_data.dart';

class NavigationStatus extends StatelessWidget {
  const NavigationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Selector<NavigationStatusViewModel, bool>(
      selector: (_, viewModel) => viewModel.isNavigating,
      builder: (context, isNavigating, child) {
        if (!isNavigating) {
          return const SizedBox.shrink();
        }
        return Selector<
          NavigationStatusViewModel,
          ({String formattedTime, String formattedDistance, int routeLength})
        >(
          selector: (_, viewModel) => (
            formattedTime: viewModel.formattedTime,
            formattedDistance: viewModel.formattedDistance,
            routeLength: viewModel.trackedRoute.length,
          ),
          builder: (context, data, child) {
            return Consumer<AdBannerViewModel>(
              builder: (context, adBannerViewModel, child) {
                const bannerHeight = 60.0;
                const defaultBottom = 32.0;
                final bottomOffset = adBannerViewModel.isLoaded
                    ? defaultBottom + bannerHeight + 8
                    : defaultBottom;

                return Positioned(
                  bottom: bottomOffset,
                  left: 20,
                  child: NavigationData(
                    data: [
                      NavigationDataItem(
                        title: l10n.distance,
                        data: data.formattedDistance,
                      ),
                      NavigationDataItem(
                        title: l10n.time,
                        data: data.formattedTime,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
