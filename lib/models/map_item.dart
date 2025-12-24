import 'package:cloud_firestore/cloud_firestore.dart';

class MapItem {
  final String id;
  final String name;
  final String path;
  final bool available;
  final int minZoom;
  final int maxZoom;

  MapItem({
    required this.id,
    required this.name,
    required this.path,
    required this.available,
    required this.minZoom,
    required this.maxZoom,
  });

  factory MapItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MapItem(
      id: doc.id,
      name: data['name'] as String,
      path: data['path'] as String,
      available: data['available'] as bool,
      minZoom: data['minZoom'] as int,
      maxZoom: data['maxZoom'] as int,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'path': path,
      'available': available,
      'minZoom': minZoom,
      'maxZoom': maxZoom,
    };
  }
}

