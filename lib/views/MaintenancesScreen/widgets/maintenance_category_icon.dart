import 'package:flutter/material.dart';
import '../../../models/maintenance_category.dart';

IconData maintenanceCategoryIcon(MaintenanceCategory category) {
  switch (category) {
    case MaintenanceCategory.engine:
      return Icons.settings_outlined;
    case MaintenanceCategory.hull:
      return Icons.directions_boat_outlined;
    case MaintenanceCategory.electrical:
      return Icons.bolt_outlined;
    case MaintenanceCategory.plumbing:
      return Icons.water_drop_outlined;
    case MaintenanceCategory.safety:
      return Icons.health_and_safety_outlined;
    case MaintenanceCategory.rigging:
      return Icons.sailing_outlined;
    case MaintenanceCategory.electronics:
      return Icons.radar_outlined;
    case MaintenanceCategory.other:
      return Icons.build_outlined;
  }
}
