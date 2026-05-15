import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/map_viewmodel.dart';

class ChartplotterCrosshair extends StatelessWidget {
  const ChartplotterCrosshair({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, bool>(
      selector: (_, vm) => vm.isChartplotterMode,
      builder: (context, enabled, _) {
        if (!enabled) return const SizedBox.shrink();
        return const IgnorePointer(
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CustomPaint(painter: _CrosshairPainter()),
            ),
          ),
        );
      },
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  const _CrosshairPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final shadow = Paint()
      ..color = Colors.black.withAlpha(160)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final half = size.width / 2;

    void drawLine(Offset a, Offset b) {
      canvas.drawLine(a, b, shadow);
      canvas.drawLine(a, b, stroke);
    }

    drawLine(Offset(0, cy), Offset(size.width, cy));
    drawLine(Offset(cx, 0), Offset(cx, size.height));
  }

  @override
  bool shouldRepaint(covariant _CrosshairPainter oldDelegate) => false;
}
