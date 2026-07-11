import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:estai/views/LoginScreen/login_screen.dart';
import 'package:estai/views/MarinaAccessScreen/marina_access_screen.dart';
import 'package:estai/widgets/location_init_wrapper.dart';
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
import 'viewmodels/raster_charts_viewmodel.dart';
import 'viewmodels/chartplotter_viewmodel.dart';
import 'viewmodels/anchor_alarm_viewmodel.dart';
import 'viewmodels/onboarding_viewmodel.dart';
import 'viewmodels/boat_viewmodel.dart';
import 'viewmodels/marina_access_viewmodel.dart';
import 'viewmodels/estai_session_viewmodel.dart';
import 'viewmodels/service_order_viewmodel.dart';
import 'services/anchor_alarm_notification_service.dart';
import 'viewmodels/signalk_configuration_viewmodel.dart';
import 'viewmodels/signalk_connection_viewmodel.dart';

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
  await AnchorAlarmNotificationService.instance.setupChannel();

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

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await WakelockPlus.enable();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final SettingsViewModel settingsViewModel;
  late final NavigationStatusViewModel navigationStatusViewModel;
  late final MapViewModel mapViewModel;
  late final WatchConnectivityViewModel watchConnectivityViewModel;
  late final SignalKConfigurationViewModel signalKConfigurationViewModel;
  late final SignalKConnectionViewModel signalKConnectionViewModel;
  late final AuthViewModel authViewModel;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  String? _pendingMarinaId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    settingsViewModel = SettingsViewModel();
    navigationStatusViewModel = NavigationStatusViewModel();
    navigationStatusViewModel.setSettingsViewModel(settingsViewModel);

    mapViewModel = MapViewModel();
    watchConnectivityViewModel = WatchConnectivityViewModel();

    signalKConfigurationViewModel = SignalKConfigurationViewModel();
    signalKConnectionViewModel = SignalKConnectionViewModel(
      config: signalKConfigurationViewModel,
      map: mapViewModel,
    );

    authViewModel = AuthViewModel();
    authViewModel.addListener(_onAuthChanged);

    _initializeWatchConnectivity();
    _initializeDeepLinks();
  }

  Future<void> _initializeWatchConnectivity() async {
    await watchConnectivityViewModel.initialize();
    watchConnectivityViewModel.setViewModels(
      mapViewModel: mapViewModel,
      navigationViewModel: navigationStatusViewModel,
    );
  }

  Future<void> _initializeDeepLinks() async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(_handleDeepLink);
  }

  void _handleDeepLink(Uri uri) {
    if (uri.scheme != 'estai' || uri.host != 'marina') return;

    final marinaId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    if (marinaId == null || marinaId.isEmpty) return;

    if (authViewModel.isAuthenticated) {
      _openMarinaAccessScreen(marinaId);
    } else {
      _pendingMarinaId = marinaId;
    }
  }

  void _onAuthChanged() {
    final marinaId = _pendingMarinaId;
    if (marinaId != null && authViewModel.isAuthenticated) {
      _pendingMarinaId = null;
      _openMarinaAccessScreen(marinaId);
    }
  }

  void _openMarinaAccessScreen(String marinaId) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => MarinaAccessScreen(marinaId: marinaId),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    authViewModel.removeListener(_onAuthChanged);
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authViewModel),
        ChangeNotifierProvider.value(value: mapViewModel),
        ChangeNotifierProvider(create: (_) => TideViewModel()),
        ChangeNotifierProvider(create: (_) => RoutePlannerViewModel()),
        ChangeNotifierProvider(create: (_) => RoutesViewModel()),
        ChangeNotifierProvider(create: (_) => ListMapsViewModel()),
        ChangeNotifierProvider(create: (_) => AdBannerViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherForecastViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherMonitorPinsViewModel()),
        ChangeNotifierProvider(create: (_) => RasterChartsViewModel()),
        ChangeNotifierProvider(create: (_) => ChartplotterViewModel()),
        ChangeNotifierProvider.value(value: settingsViewModel),
        ChangeNotifierProvider(create: (_) => NavigationPermissionViewModel()),
        ChangeNotifierProvider(create: (_) => AnchorAlarmViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => BoatViewModel()),
        ChangeNotifierProvider(create: (_) => EstaiSessionViewModel()),
        ChangeNotifierProvider(create: (_) => MarinaAccessViewModel()),
        ChangeNotifierProvider(create: (_) => ServiceOrderViewModel()),
        ChangeNotifierProvider.value(value: navigationStatusViewModel),
        ChangeNotifierProvider.value(value: watchConnectivityViewModel),
        ChangeNotifierProvider.value(value: signalKConfigurationViewModel),
        ChangeNotifierProvider.value(value: signalKConnectionViewModel),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
