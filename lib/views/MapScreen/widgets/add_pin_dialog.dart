import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/weather_monitor_pins_viewmodel.dart';

class AddPinDialog {
  static void show(
    BuildContext context,
    LatLng point,
    WeatherMonitorPinsViewModel pinsViewModel,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black.withValues(alpha: 0.9),
          title: Text(
            l10n.pinName,
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: textController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: l10n.enterPinName,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                pinsViewModel.setAddingPinMode(false);
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                final name = textController.text.trim();
                if (name.isNotEmpty) {
                  pinsViewModel.addPin(name, point.latitude, point.longitude);
                  Navigator.of(dialogContext).pop();
                  pinsViewModel.setAddingPinMode(false);
                }
              },
              child: Text(
                l10n.confirm,
                style: const TextStyle(color: Colors.lightGreen),
              ),
            ),
          ],
        );
      },
    );
  }
}
