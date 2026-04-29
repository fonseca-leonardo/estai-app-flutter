import 'package:flutter/material.dart';
import '../../../models/map_item.dart';
import '../../../services/tile_cache_service.dart';

class MapCard extends StatefulWidget {
  final MapItem mapItem;
  final bool isSelected;
  final bool isCached;
  final VoidCallback onToggleSelection;
  final VoidCallback onToggleCache;
  final VoidCallback onClearCache;

  const MapCard({
    super.key,
    required this.mapItem,
    required this.isSelected,
    required this.isCached,
    required this.onToggleSelection,
    required this.onToggleCache,
    required this.onClearCache,
  });

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  Future<int>? _cacheSizeFuture;

  @override
  void initState() {
    super.initState();
    if (widget.isCached) _refreshSize();
  }

  @override
  void didUpdateWidget(MapCard old) {
    super.didUpdateWidget(old);
    if (widget.isCached && !old.isCached) _refreshSize();
    if (!widget.isCached) _cacheSizeFuture = null;
  }

  void _refreshSize() {
    _cacheSizeFuture = TileCacheService.instance.getCacheSizeBytes(
      widget.mapItem.id,
    );
  }

  void _onClearCache() {
    widget.onClearCache();
    setState(() {
      _cacheSizeFuture = Future.value(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onToggleSelection,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? Colors.blue.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isSelected
                ? Colors.blue.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.2),
            width: widget.isSelected ? 2 : 1,
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
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.mapItem.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: widget.isSelected,
                    onChanged: (_) => widget.onToggleSelection(),
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.zoom_in,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Zoom: ${widget.mapItem.minZoom} - ${widget.mapItem.maxZoom}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
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

class _CacheRow extends StatelessWidget {
  final bool isCached;
  final Future<int>? cacheSizeFuture;
  final VoidCallback onToggle;
  final VoidCallback onClear;

  const _CacheRow({
    required this.isCached,
    required this.cacheSizeFuture,
    required this.onToggle,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isCached ? Icons.download_done : Icons.download_outlined,
              size: 16,
              color: isCached
                  ? Colors.greenAccent.withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 4),
            Text(
              'Armazenamento local',
              style: TextStyle(
                color: isCached
                    ? Colors.greenAccent.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onToggle,
              child: Switch(
                value: isCached,
                onChanged: (_) => onToggle(),
                activeThumbColor: Colors.greenAccent,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        if (isCached && cacheSizeFuture != null)
          FutureBuilder<int>(
            future: cacheSizeFuture,
            builder: (context, snapshot) {
              final size = snapshot.hasData
                  ? formatCacheBytes(snapshot.data!)
                  : '...';
              return Row(
                children: [
                  Text(
                    size,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onClear,
                    child: Text(
                      'Limpar',
                      style: TextStyle(
                        color: Colors.redAccent.withValues(alpha: 0.8),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.redAccent.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
