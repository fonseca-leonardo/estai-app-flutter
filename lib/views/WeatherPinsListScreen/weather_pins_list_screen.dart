import 'package:estai/widgets/ad_banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/weather_monitor_pins_viewmodel.dart';
import '../../models/weather_monitor_pin.dart';
import '../../utils/coordinate_formatter.dart';
import '../MapScreen/map_screen.dart';

class WeatherPinsListScreen extends StatelessWidget {
  const WeatherPinsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(l10n.weatherPinsList),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WeatherMonitorPinsViewModel>(
        builder: (context, pinsViewModel, child) {
          if (pinsViewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (pinsViewModel.pins.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.thermostat, size: 64, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noPinsAdded,
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: pinsViewModel.pins.length,
            itemBuilder: (context, index) {
              final pin = pinsViewModel.pins[index];
              return _PinCard(
                pin: pin,
                onEdit: () => _showEditPinDialog(context, pin, pinsViewModel),
                onDelete: () =>
                    _showDeleteConfirmation(context, pin, pinsViewModel),
                onNavigateToMap: () => _navigateToMap(context, pin),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }

  void _showEditPinDialog(
    BuildContext context,
    WeatherMonitorPin pin,
    WeatherMonitorPinsViewModel viewModel,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: pin.name);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          l10n.editPinName,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: l10n.pinName,
            labelStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                viewModel.updatePinName(pin.id, newName);
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(
              l10n.save,
              style: const TextStyle(color: Colors.lightGreen),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WeatherMonitorPin pin,
    WeatherMonitorPinsViewModel viewModel,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          l10n.deletePin,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.confirmDeletePin(pin.name),
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              viewModel.removePin(pin.id);
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              l10n.deletePin,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMap(BuildContext context, WeatherMonitorPin pin) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            MapScreen(initialLocation: pin.position, pinIdToOpen: pin.id),
      ),
    );
  }
}

class _PinCard extends StatelessWidget {
  final WeatherMonitorPin pin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onNavigateToMap;

  const _PinCard({
    required this.pin,
    required this.onEdit,
    required this.onDelete,
    required this.onNavigateToMap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: InkWell(
        onTap: onNavigateToMap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.thermostat, color: Colors.cyan, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      pin.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.latitude}: ${CoordinateFormatter.formatLatitude(pin.latitude)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${l10n.longitude}: ${CoordinateFormatter.formatLongitude(pin.longitude)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 18),
                    label: Text(l10n.deletePin),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    label: Text(l10n.editPinName),
                    style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
