import 'package:cloud_firestore/cloud_firestore.dart';

class MapItem {
  final String id;
  final String name;
  final String path;
  final bool available;
  final int minZoom;
  final int maxZoom;
  final bool isPrimary;
  final int priority;

  MapItem({
    required this.id,
    required this.name,
    required this.path,
    required this.available,
    required this.minZoom,
    required this.maxZoom,
    this.isPrimary = false,
    this.priority = 0,
  });

  factory MapItem.fromJson(Map<String, dynamic> json) {
    return MapItem(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      available: json['available'] as bool,
      minZoom: json['minZoom'] as int,
      maxZoom: json['maxZoom'] as int,
      isPrimary: json['isPrimary'] as bool? ?? false,
      priority: json['priority'] as int? ?? 0,
    );
  }

  factory MapItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MapItem(
      id: doc.id,
      name: data['name'] as String,
      path: data['path'] as String,
      available: data['available'] as bool,
      minZoom: data['minZoom'] as int,
      maxZoom: data['maxZoom'] as int,
      isPrimary: data['isPrimary'] as bool? ?? false,
      priority: data['priority'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'path': path,
      'available': available,
      'minZoom': minZoom,
      'maxZoom': maxZoom,
      'isPrimary': isPrimary,
      'priority': priority,
    };
  }
}
