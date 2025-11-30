import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/map_viewmodel.dart';
import '../../../components/navigation_data.dart';
import '../../../utils/coordinate_formatter.dart';

class MapNavigationData extends StatelessWidget {
  const MapNavigationData({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 48,
      right: 20,
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // VEL e HDG - observa apenas speed e heading
          Selector<MapViewModel, ({double? speed, double? heading})>(
            selector: (_, viewModel) => (
              speed: viewModel.currentSpeed,
              heading: viewModel.currentHeading,
            ),
            builder: (context, data, child) {
              return NavigationData(
                data: [
                  NavigationDataItem(
                    title: 'VEL',
                    data: CoordinateFormatter.formatSpeedInKnots(data.speed),
                  ),
                  NavigationDataItem(
                    title: 'HDG',
                    data: CoordinateFormatter.formatHeading(data.heading),
                  ),
                ],
              );
            },
          ),
          // LAT - observa apenas latitude
          Selector<MapViewModel, double?>(
            selector: (_, viewModel) => viewModel.currentPosition?.latitude,
            builder: (context, latitude, child) {
              return NavigationData(
                data: [
                  NavigationDataItem(
                    title: 'LAT',
                    data: latitude != null
                        ? CoordinateFormatter.formatLatitude(latitude)
                        : '--º --\' --" --',
                  ),
                ],
              );
            },
          ),
          // LON - observa apenas longitude
          Selector<MapViewModel, double?>(
            selector: (_, viewModel) => viewModel.currentPosition?.longitude,
            builder: (context, longitude, child) {
              return NavigationData(
                data: [
                  NavigationDataItem(
                    title: 'LON',
                    data: longitude != null
                        ? CoordinateFormatter.formatLongitude(longitude)
                        : '--º --\' --" --',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
