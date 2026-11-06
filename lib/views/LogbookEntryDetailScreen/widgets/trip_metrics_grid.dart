import 'package:flutter/material.dart';

/// Distribui as métricas lado a lado, em duas colunas.
class TripMetricsGrid extends StatelessWidget {
  final List<Widget> children;

  const TripMetricsGrid({super.key, required this.children});

  static const double _gap = 12;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - _gap) / 2;
        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}
