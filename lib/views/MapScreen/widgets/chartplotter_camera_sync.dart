import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/chartplotter_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';

/// Invisible map child that mirrors the [MapCamera] center into
/// [ChartplotterViewModel] so widgets outside [FlutterMap] can react to it.
class ChartplotterCameraSync extends StatelessWidget {
  const ChartplotterCameraSync({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, bool>(
      selector: (_, vm) => vm.isChartplotterMode,
      builder: (context, enabled, _) {
        if (!enabled) return const SizedBox.shrink();
        final center = MapCamera.of(context).center;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          context.read<ChartplotterViewModel>().updateCenter(center);
        });
        return const SizedBox.shrink();
      },
    );
  }
}
