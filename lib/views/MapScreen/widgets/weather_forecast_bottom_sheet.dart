import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/coordinate_formatter.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';
import '../../../viewmodels/weather_forecast_viewmodel.dart';
import '../../LoginScreen/login_screen.dart';
import '../../SignUpScreen/sign_up_screen.dart';
import 'weather_timeline_item.dart';

class WeatherForecastBottomSheet extends StatefulWidget {
  final BuildContext? parentContext;

  const WeatherForecastBottomSheet({super.key, this.parentContext});

  @override
  State<WeatherForecastBottomSheet> createState() =>
      _WeatherForecastBottomSheetState();

  static void show(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context, listen: false);
    final weatherViewModel = Provider.of<WeatherForecastViewModel>(
      context,
      listen: false,
    );

    final position = mapViewModel.currentPosition;
    if (position != null) {
      if (weatherViewModel.shouldFetchForecasts(
        position.latitude,
        position.longitude,
      )) {
        weatherViewModel.fetchForecasts(position.latitude, position.longitude);
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.65),
      isScrollControlled: true,
      useRootNavigator: false,
      enableDrag: true,
      useSafeArea: true,
      builder: (bottomSheetContext) =>
          WeatherForecastBottomSheet(parentContext: context),
    );
  }
}

class _WeatherForecastBottomSheetState
    extends State<WeatherForecastBottomSheet> {
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
        final time = DateTime.parse(viewModel.forecastData[i].time);
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
    final mapViewModel = Provider.of<MapViewModel>(context, listen: false);

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
            Text(
              l10n.weatherForecast,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Consumer2<WeatherForecastViewModel, AuthViewModel>(
              builder: (context, viewModel, authViewModel, child) {
                if (!authViewModel.isAuthenticated) {
                  return SizedBox(
                    width: double.infinity,
                    child: Container(
                      child: Column(
                        children: [
                          const Icon(Icons.lock_outline, color: Colors.white),
                          const SizedBox(height: 12),
                          Text(
                            l10n.loginRequiredForForecast,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(l10n.goToLogin),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(l10n.createAccount),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
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
                              final lastLat = viewModel.lastFetchLatitude;
                              final lastLon = viewModel.lastFetchLongitude;
                              if (lastLat != null && lastLon != null) {
                                viewModel.fetchForecasts(lastLat, lastLon);
                              } else {
                                final position = mapViewModel.currentPosition;
                                if (position != null) {
                                  viewModel.fetchForecasts(
                                    position.latitude,
                                    position.longitude,
                                  );
                                }
                              }
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
                    final time = DateTime.parse(viewModel.forecastData[i].time);
                    if (time.isAfter(now) || time.isAtSameMomentAs(now)) {
                      currentHourIndex = i;
                      break;
                    }
                  } catch (e) {
                    continue;
                  }
                }

                _scrollToCurrentHour(viewModel.forecastData);

                final latitude = viewModel.lastFetchLatitude;
                final longitude = viewModel.lastFetchLongitude;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (latitude != null && longitude != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.white.withValues(alpha: 0.78),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${l10n.latitude}: ${CoordinateFormatter.formatLatitude(latitude)}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.78,
                                      ),
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${l10n.longitude}: ${CoordinateFormatter.formatLongitude(longitude)}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.78,
                                      ),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
