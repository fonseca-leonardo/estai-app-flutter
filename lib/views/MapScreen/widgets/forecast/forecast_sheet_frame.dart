import 'package:flutter/material.dart';
import '../../../../theme/app_glass.dart';
import '../../../../theme/app_radius.dart';
import '../../../../widgets/ui/glass_surface.dart';

/// Moldura de vidro dos sheets de previsão: alça, cabeçalho fixo e corpo
/// rolável até 85% da altura da tela.
class ForecastSheetFrame extends StatelessWidget {
  final Widget header;
  final Widget body;

  const ForecastSheetFrame({
    super.key,
    required this.header,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return GlassSurface(
      borderRadius: AppRadius.sheetTop,
      border: Border(top: BorderSide(color: AppGlass.border)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: header,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  20 + MediaQuery.paddingOf(context).bottom,
                ),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
