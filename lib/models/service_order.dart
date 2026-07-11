import 'service_order_status.dart';

class ServiceOrder {
  final String id;
  final String marinaId;
  final String? priceItemId;
  final String? priceItemName;
  final String? clientId;
  final String? clientName;
  final String? boatId;
  final String? boatName;
  final String? marinaLocationId;
  final String? assignedTo;
  final String? assignedUserName;
  final String description;
  final double price;
  final ServiceOrderStatus status;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceOrder({
    required this.id,
    required this.marinaId,
    this.priceItemId,
    this.priceItemName,
    this.clientId,
    this.clientName,
    this.boatId,
    this.boatName,
    this.marinaLocationId,
    this.assignedTo,
    this.assignedUserName,
    required this.description,
    required this.price,
    required this.status,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  ServiceOrder copyWith({ServiceOrderStatus? status}) {
    return ServiceOrder(
      id: id,
      marinaId: marinaId,
      priceItemId: priceItemId,
      priceItemName: priceItemName,
      clientId: clientId,
      clientName: clientName,
      boatId: boatId,
      boatName: boatName,
      marinaLocationId: marinaLocationId,
      assignedTo: assignedTo,
      assignedUserName: assignedUserName,
      description: description,
      price: price,
      status: status ?? this.status,
      scheduledAt: scheduledAt,
      startedAt: startedAt,
      completedAt: completedAt,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ServiceOrder.fromJson(Map<String, dynamic> json) {
    return ServiceOrder(
      id: json['id'] as String,
      marinaId: json['marinaId'] as String,
      priceItemId: json['priceItemId'] as String?,
      priceItemName: json['priceItemName'] as String?,
      clientId: json['clientId'] as String?,
      clientName: json['clientName'] as String?,
      boatId: json['boatId'] as String?,
      boatName: json['boatName'] as String?,
      marinaLocationId: json['marinaLocationId'] as String?,
      assignedTo: json['assignedTo'] as String?,
      assignedUserName: json['assignedUserName'] as String?,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      status: ServiceOrderStatus.fromApiValue(json['status'] as String),
      scheduledAt: DateTime.tryParse(json['scheduledAt'] as String? ?? ''),
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? ''),
      completedAt: DateTime.tryParse(json['completedAt'] as String? ?? ''),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
