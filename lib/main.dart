import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'views/MapScreen/map_screen.dart';
import 'viewmodels/map_viewmodel.dart';
import 'viewmodels/tide_viewmodel.dart';
import 'viewmodels/route_planner_viewmodel.dart';
import 'viewmodels/navigation_status_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Lock to portrait up
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => TideViewModel()),
        ChangeNotifierProvider(create: (_) => RoutePlannerViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationStatusViewModel()),
      ],
      child: MaterialApp(
        title: 'Estai - Mapa',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MapScreen(),
      ),
    );
  }
}
