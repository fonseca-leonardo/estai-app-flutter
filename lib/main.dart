import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/LoginScreen/login_screen.dart';
import 'viewmodels/map_viewmodel.dart';
import 'viewmodels/tide_viewmodel.dart';
import 'viewmodels/route_planner_viewmodel.dart';
import 'viewmodels/navigation_status_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = SettingsViewModel();
    final navigationStatusViewModel = NavigationStatusViewModel();
    navigationStatusViewModel.setSettingsViewModel(settingsViewModel);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => TideViewModel()),
        ChangeNotifierProvider(create: (_) => RoutePlannerViewModel()),
        ChangeNotifierProvider.value(value: settingsViewModel),
        ChangeNotifierProvider.value(value: navigationStatusViewModel),
      ],
      child: MaterialApp(
        title: 'Estai - Mapa',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
