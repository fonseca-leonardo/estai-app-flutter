import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/route.dart' as route_model;
import '../../../theme/app_colors.dart';
import '../../../theme/app_glass.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/ui/glass_card.dart';
import '../../../widgets/ui/icon_chip.dart';
import 'route_meta_row.dart';

enum RouteCardAction { edit, delete }

/// Card de vidro de uma rota salva, com menu de editar/apagar.
class RouteCard extends StatelessWidget {
  final route_model.Route route;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RouteCard({
    super.key,
    required this.route,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return GlassCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.lg,
      ),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs),
            child: IconChip(icon: Icons.route),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Column(
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
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.lg,
                    runSpacing: AppSpacing.xs,
                    children: [
                      RouteMetaRow(
                        icon: Icons.location_on_outlined,
                        text: '${route.points.length} ${l10n.points}',
                      ),
                      RouteMetaRow(
                        icon: Icons.calendar_today_outlined,
                        text: dateFormat.format(route.createdAt),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<RouteCardAction>(
            icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
            color: Colors.black.withValues(alpha: 0.85),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppGlass.border),
            ),
            onSelected: (action) {
              switch (action) {
                case RouteCardAction.edit:
                  onEdit();
                case RouteCardAction.delete:
                  onDelete();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: RouteCardAction.edit,
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.editRouteName,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: RouteCardAction.delete,
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      color: AppColors.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.deleteRoute,
                      style: const TextStyle(color: AppColors.danger),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
