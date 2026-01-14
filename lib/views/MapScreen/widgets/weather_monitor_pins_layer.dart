import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/weather_monitor_pins_viewmodel.dart';
import 'weather_monitor_pin_widget.dart';
import 'weather_pin_forecast_bottom_sheet.dart';

class WeatherMonitorPinsLayer extends StatelessWidget {
  const WeatherMonitorPinsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherMonitorPinsViewModel>(
      builder: (context, pinsViewModel, child) {
        if (pinsViewModel.pins.isEmpty) {
          return const SizedBox.shrink();
        }

        return MarkerLayer(
          markers: pinsViewModel.pins.map((pin) {
            return Marker(
              point: pin.position,
              width: 28,
              height: 28,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  WeatherPinForecastBottomSheet.show(context, pin);
                },
                child: const WeatherMonitorPinWidget(),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
