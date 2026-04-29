import 'package:flutter/widgets.dart';
import '../services/analytics_service.dart';

mixin AnalyticsScreenMixin<T extends StatefulWidget> on State<T> {
  String get analyticsScreenName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.instance.logScreenView(analyticsScreenName);
    });
  }
}
