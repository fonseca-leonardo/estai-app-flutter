import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/forecast_metric.dart';
import '../../../../widgets/selectable_pill.dart';

/// Pílulas para escolher a métrica do gráfico.
class ForecastMetricSelector extends StatelessWidget {
  final ForecastMetric selected;
  final ValueChanged<ForecastMetric> onChanged;

  const ForecastMetricSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final metric in ForecastMetric.values) ...[
            SelectablePill(
              icon: metric.icon,
              label: metric.label(l10n),
              selected: metric == selected,
              onTap: () => onChanged(metric),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
