import 'package:flutter/material.dart';

import '../../theme/app_glass.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'glass_surface.dart';

/// Bottom sheet padrão: handle, cantos superiores arredondados, borda sutil e
/// espaço para o teclado.
class AppSheet {
  AppSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool useRootNavigator = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = true,
    // `false` para sheets que já montam o próprio conteúdo/padding.
    bool padded = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: useSafeArea,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (sheetContext) => GlassSurface(
        borderRadius: AppRadius.sheetTop,
        border: Border(top: BorderSide(color: AppGlass.border)),
        child: !padded
            ? builder(sheetContext)
            : Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.xl,
                  AppSpacing.xl + MediaQuery.of(sheetContext).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Flexible(child: builder(sheetContext)),
                  ],
                ),
              ),
      ),
    );
  }
}
