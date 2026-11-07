import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/route.dart' as route_model;
import '../../../theme/app_colors.dart';
import '../../../utils/route_geometry.dart';
import '../../../widgets/ui/glass_dialog.dart';
import 'route_meta_row.dart';

/// `true` quando o usuário escolheu navegar com a rota.
Future<bool> showRouteDetailsDialog(
  BuildContext context,
  route_model.Route route,
) async {
  final l10n = AppLocalizations.of(context)!;
  final distance = RouteGeometry.formatNauticalMiles(
    RouteGeometry.totalDistanceMeters(route.points),
  );

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => GlassDialog(
      title: l10n.routeDetails,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            route.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          RouteMetaRow(
            icon: Icons.location_on_outlined,
            text: '${route.points.length} ${l10n.points}',
          ),
          const SizedBox(height: 8),
          RouteMetaRow(
            icon: Icons.straighten,
            text: '${l10n.totalDistance}: $distance',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: route.points.isEmpty
              ? null
              : () => Navigator.of(dialogContext).pop(true),
          child: Text(
            l10n.startNavigationWithRoute,
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
