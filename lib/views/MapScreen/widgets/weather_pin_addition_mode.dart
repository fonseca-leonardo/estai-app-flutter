import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/weather_monitor_pins_viewmodel.dart';

class WeatherPinAdditionMode extends StatelessWidget {
  const WeatherPinAdditionMode({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<WeatherMonitorPinsViewModel>(
      builder: (context, pinsViewModel, child) {
        if (!pinsViewModel.isAddingPin) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 164,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(140),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.tapMapToAddPin,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(140),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        pinsViewModel.setAddingPinMode(false);
                      },
                      tooltip: l10n.cancel,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
