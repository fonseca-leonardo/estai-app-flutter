import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/navigation_status_viewmodel.dart';
import '../../../components/navigation_data.dart';

class NavigationStatus extends StatelessWidget {
  const NavigationStatus({super.key});

  @override
  Widget build(BuildContext context) {
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
            return Positioned(
              bottom: 20,
              left: 20,
              child: NavigationData(
                data: [
                  NavigationDataItem(
                    title: 'DIST',
                    data: data.formattedDistance,
                  ),
                  NavigationDataItem(title: 'TEMPO', data: data.formattedTime),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
