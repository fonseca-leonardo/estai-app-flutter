import 'package:estai/l10n/app_localizations.dart';
import 'package:estai/models/forecast_metric.dart';
import 'package:estai/viewmodels/weather_forecast_viewmodel.dart';
import 'package:estai/views/MapScreen/widgets/forecast/forecast_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../viewmodels/weather_forecast_viewmodel_test.dart'
    show FakeMeteoService, apiTime;

void main() {
  testWidgets('renders every metric without layout errors', (tester) async {
    final start = DateTime.now().toUtc();
    final times = [
      for (var i = 0; i < 72; i++)
        apiTime(
          DateTime.utc(
            start.year,
            start.month,
            start.day,
            start.hour,
          ).add(Duration(hours: i)),
        ),
    ];
    final viewModel = WeatherForecastViewModel(
      meteoService: FakeMeteoService(times),
    );
    await viewModel.fetchForecasts(-23, -45);

    await tester.binding.setSurfaceSize(const Size(375, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) =>
                  ForecastPanel(viewModel: viewModel, onRetry: () {}),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AGORA'), findsOneWidget);
    expect(find.textContaining('Vento aumenta'), findsOneWidget);

    for (final metric in ForecastMetric.values) {
      viewModel.selectMetric(metric);
      await tester.pumpAndSettle();
      final error = tester.takeException();
      if (error != null) debugPrint('METRIC $metric: $error');
      expect(error, isNull);
    }

    await tester.tap(
      find.textContaining('Mais detalhes').first,
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
