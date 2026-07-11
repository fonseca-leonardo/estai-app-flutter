import 'service_price_unit.dart';

class ServicePriceItem {
  final String id;
  final String marinaId;
  final String name;
  final String? description;
  final String type;
  final String category;
  final double defaultPrice;
  final ServicePriceUnit unit;
  final bool isActive;

  ServicePriceItem({
    required this.id,
    required this.marinaId,
    required this.name,
    this.description,
    required this.type,
    required this.category,
    required this.defaultPrice,
    required this.unit,
    required this.isActive,
  });

  factory ServicePriceItem.fromJson(Map<String, dynamic> json) {
    return ServicePriceItem(
      id: json['id'] as String,
      marinaId: json['marinaId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      category: json['category'] as String,
      defaultPrice: (json['defaultPrice'] as num).toDouble(),
      unit: ServicePriceUnit.fromApiValue(json['unit'] as String),
      isActive: json['isActive'] as bool,
    );
  }
}
