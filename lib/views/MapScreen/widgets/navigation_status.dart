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
        return Selector<NavigationStatusViewModel, String>(
          selector: (_, viewModel) => viewModel.formattedTime,
          builder: (context, formattedTime, child) {
            return Positioned(
              bottom: 20,
              left: 20,
              child: NavigationData(
                data: [NavigationDataItem(title: 'Tempo', data: formattedTime)],
              ),
            );
          },
        );
      },
    );
  }
}
