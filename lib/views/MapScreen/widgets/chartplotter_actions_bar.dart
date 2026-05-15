import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/chartplotter_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';
import 'chartplotter_action_button.dart';
import 'chartplotter_selected_charts_bottom_sheet.dart';

class ChartplotterActionsBar extends StatelessWidget {
  const ChartplotterActionsBar({super.key});

  static const double _offsetBelowCrosshair = 48;

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, bool>(
      selector: (_, vm) => vm.isChartplotterMode,
      builder: (context, enabled, _) {
        if (!enabled) return const SizedBox.shrink();
        return IgnorePointer(
          ignoring: false,
          child: Center(
            child: Transform.translate(
              offset: const Offset(0, _offsetBelowCrosshair),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [_SelectedChartsButton()],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectedChartsButton extends StatelessWidget {
  const _SelectedChartsButton();

  @override
  Widget build(BuildContext context) {
    return Selector<ChartplotterViewModel, int>(
      selector: (_, vm) => vm.selectedCharts.length,
      builder: (context, count, _) {
        return ChartplotterActionButton(
          icon: Icons.map_outlined,
          badgeCount: count,
          tooltip: 'Cartas no centro',
          onTap: () => ChartplotterSelectedChartsBottomSheet.show(context),
        );
      },
    );
  }
}
