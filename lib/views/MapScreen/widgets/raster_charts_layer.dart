import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/raster_charts_viewmodel.dart';

class RasterChartsLayer extends StatelessWidget {
  const RasterChartsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RasterChartsViewModel>(
      builder: (context, viewModel, _) {
        final charts = viewModel.visibleCharts;
        if (charts.isEmpty) return const SizedBox.shrink();
        return OverlayImageLayer(
          overlayImages: charts
              .map(
                (chart) => RotatedOverlayImage(
                  topLeftCorner: chart.nw,
                  bottomLeftCorner: chart.sw,
                  bottomRightCorner: chart.se,
                  imageProvider: FileImage(File(chart.pngPath)),
                  opacity: 1.0,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
