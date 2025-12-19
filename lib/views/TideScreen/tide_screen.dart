import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/map_viewmodel.dart';
import '../../viewmodels/tide_viewmodel.dart';
import 'pdf_viewer_screen.dart';

class TideScreen extends StatefulWidget {
  const TideScreen({super.key});

  @override
  State<TideScreen> createState() => _TideScreenState();
}

class _TideScreenState extends State<TideScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mapViewModel = context.read<MapViewModel>();
      final userPosition = mapViewModel.currentPosition;
      context.read<TideViewModel>().fetchTideStations(
        userPosition: userPosition,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      sized: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(l10n.tideTables),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Consumer2<TideViewModel, MapViewModel>(
                builder: (context, tideViewModel, mapViewModel, child) {
                  if (tideViewModel.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (tideViewModel.errorMessage != null) {
                    final errorKey = tideViewModel.errorMessage!;
                    String errorText;
                    if (errorKey.contains(':')) {
                      final parts = errorKey.split(':');
                      final key = parts[0];
                      final param = parts.length > 1 ? parts[1] : '';
                      switch (key) {
                        case 'errorLoadingTideTables':
                          errorText = l10n.errorLoadingTideTables(param);
                          break;
                        default:
                          errorText = errorKey;
                      }
                    } else {
                      errorText = errorKey;
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            errorText,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              final userPosition = mapViewModel.currentPosition;
                              tideViewModel.fetchTideStations(
                                userPosition: userPosition,
                              );
                            },
                            child: Text(l10n.tryAgain),
                          ),
                        ],
                      ),
                    );
                  }

                  if (tideViewModel.tideStations.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noTideTablesFound,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final userPosition = mapViewModel.currentPosition;

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    itemCount: tideViewModel.tideStations.length,
                    itemBuilder: (context, index) {
                      final station = tideViewModel.tideStations[index];
                      final distance = tideViewModel.getDistanceToStation(
                        station,
                        userPosition,
                      );
                      final distanceText = distance != null
                          ? tideViewModel.formatDistance(distance)
                          : null;

                      return Card(
                        color: Colors.white.withOpacity(0.1),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            station.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                station.latLongText,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              if (distanceText != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  distanceText,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfViewerScreen(
                                    pdfUrl: tideViewModel.getPdfUrl(station.id),
                                    title: station.name,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
