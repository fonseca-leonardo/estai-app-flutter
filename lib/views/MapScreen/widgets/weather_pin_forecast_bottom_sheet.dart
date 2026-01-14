import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/coordinate_formatter.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/weather_forecast_viewmodel.dart';
import '../../../viewmodels/weather_monitor_pins_viewmodel.dart';
import '../../../models/weather_monitor_pin.dart';
import 'login_required_widget.dart';
import 'weather_timeline_item.dart';

class WeatherPinForecastBottomSheet extends StatefulWidget {
  final WeatherMonitorPin pin;

  const WeatherPinForecastBottomSheet({super.key, required this.pin});

  @override
  State<WeatherPinForecastBottomSheet> createState() =>
      _WeatherPinForecastBottomSheetState();

  static void show(BuildContext context, WeatherMonitorPin pin) {
    final weatherViewModel = Provider.of<WeatherForecastViewModel>(
      context,
      listen: false,
    );

    if (weatherViewModel.shouldFetchForecasts(
      pin.latitude,
      pin.longitude,
    )) {
      weatherViewModel.fetchForecasts(pin.latitude, pin.longitude);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.65),
      isScrollControlled: true,
      useRootNavigator: false,
      enableDrag: true,
      useSafeArea: true,
      builder: (bottomSheetContext) =>
          WeatherPinForecastBottomSheet(pin: pin),
    );
  }
}

class _WeatherPinForecastBottomSheetState
    extends State<WeatherPinForecastBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToCurrent = false;
  int? _lastDataLength = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollChanged);
  }

  void _onScrollChanged() {
    if (_scrollController.hasClients && !_hasScrolledToCurrent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _tryScrollToCurrent();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentHour(List<ForecastHourData> forecastData) {
    if (forecastData.isEmpty) return;

    if (_lastDataLength == forecastData.length && _hasScrolledToCurrent) {
      return;
    }

    _lastDataLength = forecastData.length;
    _hasScrolledToCurrent = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _tryScrollToCurrent();
        }
      });
    });
  }

  void _tryScrollToCurrent() {
    if (_hasScrolledToCurrent || !_scrollController.hasClients) return;

    final viewModel = Provider.of<WeatherForecastViewModel>(
      context,
      listen: false,
    );

    if (viewModel.forecastData.isEmpty) return;

    final now = DateTime.now();
    int? currentHourIndex;

    for (int i = 0; i < viewModel.forecastData.length; i++) {
      try {
        final timeUtc = DateTime.parse(
          viewModel.forecastData[i].time + 'Z',
        ).toUtc();
        final time = timeUtc.toLocal();
        if (time.isAfter(now) || time.isAtSameMomentAs(now)) {
          currentHourIndex = i;
          break;
        }
      } catch (e) {
        continue;
      }
    }

    if (currentHourIndex == null) {
      currentHourIndex = 0;
    }

    const itemWidth = 200.0 + 12.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final scrollPosition =
        (currentHourIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    _hasScrolledToCurrent = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(164, 0, 0, 0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.thermostat,
                  color: Colors.cyan,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.pin.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              spacing: 8,
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.78),
                ),
                Text(
                  '${l10n.latitude}: ${CoordinateFormatter.formatLatitude(widget.pin.latitude)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${l10n.longitude}: ${CoordinateFormatter.formatLongitude(widget.pin.longitude)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Consumer2<WeatherForecastViewModel, AuthViewModel>(
              builder: (context, viewModel, authViewModel, child) {
                if (!authViewModel.isAuthenticated) {
                  return const LoginRequiredWidget();
                }

                if (viewModel.isLoading) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }

                if (viewModel.errorMessage != null) {
                  return SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.39),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white),
                          const SizedBox(height: 8),
                          Text(
                            l10n.errorLoadingForecast,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () {
                              viewModel.fetchForecasts(
                                widget.pin.latitude,
                                widget.pin.longitude,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(l10n.tryAgain),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (viewModel.forecastData.isEmpty) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        l10n.noForecastAvailable,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                final now = DateTime.now();
                int? currentHourIndex;

                for (int i = 0; i < viewModel.forecastData.length; i++) {
                  try {
                    final timeUtc = DateTime.parse(
                      viewModel.forecastData[i].time + 'Z',
                    ).toUtc();
                    final time = timeUtc.toLocal();
                    if (time.isAfter(now) || time.isAtSameMomentAs(now)) {
                      currentHourIndex = i;
                      break;
                    }
                  } catch (e) {
                    continue;
                  }
                }

                _scrollToCurrentHour(viewModel.forecastData);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 440,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.forecastData.length,
                        itemBuilder: (context, index) {
                          final isCurrentHour = index == currentHourIndex;
                          return WeatherTimelineItem(
                            data: viewModel.forecastData[index],
                            isCurrentHour: isCurrentHour,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final pinsViewModel = Provider.of<WeatherMonitorPinsViewModel>(
                    context,
                    listen: false,
                  );
                  pinsViewModel.removePin(widget.pin.id);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete, color: Colors.white),
                label: Text(
                  l10n.deletePin,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
