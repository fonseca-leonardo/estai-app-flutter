import 'package:estai/views/LoginScreen/login_screen.dart';
import 'package:estai/widgets/location_init_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'services/analytics_service.dart';
import 'views/MbtilesTestScreen/mbtiles_test_screen.dart';
import 'viewmodels/map_viewmodel.dart';
import 'viewmodels/tide_viewmodel.dart';
import 'viewmodels/route_planner_viewmodel.dart';
import 'viewmodels/navigation_status_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'viewmodels/navigation_permission_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/routes_viewmodel.dart';
import 'viewmodels/list_maps_viewmodel.dart';
import 'viewmodels/ad_banner_viewmodel.dart';
import 'viewmodels/weather_forecast_viewmodel.dart';
import 'viewmodels/weather_monitor_pins_viewmodel.dart';
import 'viewmodels/watch_connectivity_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception.toString();
    if (exception.contains('Request to') &&
        exception.contains('failed with status 404') &&
        exception.contains('maps-api.estai.com.br')) {
      return;
    }
    FlutterError.presentError(details);
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AnalyticsService.instance.initialize();

  // if (kDebugMode) {
  //   await FirebaseAppCheck.instance.activate(
  //     providerAndroid: AndroidDebugProvider(),
  //     providerApple: AppleDebugProvider(),
  //   );
  // } else {
  //   await FirebaseAppCheck.instance.activate(
  //     providerAndroid: AndroidPlayIntegrityProvider(),
  //     providerApple: AppleAppAttestProvider(),
  //   );
  // }

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  final initializationStatus = await MobileAds.instance.initialize();
  if (kDebugMode) {
    debugPrint(
      'MobileAds initialized: ${initializationStatus.adapterStatuses}',
    );
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await WakelockPlus.enable();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final SettingsViewModel settingsViewModel;
  late final NavigationStatusViewModel navigationStatusViewModel;
  late final MapViewModel mapViewModel;
  late final WatchConnectivityViewModel watchConnectivityViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    settingsViewModel = SettingsViewModel();
    navigationStatusViewModel = NavigationStatusViewModel();
    navigationStatusViewModel.setSettingsViewModel(settingsViewModel);

    mapViewModel = MapViewModel();
    watchConnectivityViewModel = WatchConnectivityViewModel();

    _initializeWatchConnectivity();
  }

  Future<void> _initializeWatchConnectivity() async {
    await watchConnectivityViewModel.initialize();
    watchConnectivityViewModel.setViewModels(
      mapViewModel: mapViewModel,
      navigationViewModel: navigationStatusViewModel,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider.value(value: mapViewModel),
        ChangeNotifierProvider(create: (_) => TideViewModel()),
        ChangeNotifierProvider(create: (_) => RoutePlannerViewModel()),
        ChangeNotifierProvider(create: (_) => RoutesViewModel()),
        ChangeNotifierProvider(create: (_) => ListMapsViewModel()),
        ChangeNotifierProvider(create: (_) => AdBannerViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherForecastViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherMonitorPinsViewModel()),
        ChangeNotifierProvider.value(value: settingsViewModel),
        ChangeNotifierProvider(create: (_) => NavigationPermissionViewModel()),
        ChangeNotifierProvider.value(value: navigationStatusViewModel),
        ChangeNotifierProvider.value(value: watchConnectivityViewModel),
      ],
      child: MaterialApp(
        title: 'Estai - Mapa',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            primary: Colors.white,
          ),
          useMaterial3: true,
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.white,
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
        home: const LocationInitWrapper(child: LoginScreen()),
      ),
    );
  }
}
