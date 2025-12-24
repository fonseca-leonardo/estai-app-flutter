import 'package:flutter/material.dart';
import '../../../models/map_item.dart';

class MapCard extends StatelessWidget {
  final MapItem mapItem;
  final bool isSelected;
  final VoidCallback onToggleSelection;

  const MapCard({
    super.key,
    required this.mapItem,
    required this.isSelected,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggleSelection,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.blue.withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.map,
                    color: Colors.white.withOpacity(0.7),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      mapItem.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onToggleSelection(),
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.zoom_in,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Zoom: ${mapItem.minZoom} - ${mapItem.maxZoom}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
