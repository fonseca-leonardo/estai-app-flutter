class MarinaLocation {
  final String id;
  final String name;
  final String street;
  final String number;
  final String? complement;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final String? latitude;
  final String? longitude;

  const MarinaLocation({
    required this.id,
    required this.name,
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    this.latitude,
    this.longitude,
  });

  factory MarinaLocation.fromJson(Map<String, dynamic> json) {
    return MarinaLocation(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      street: json['street'] as String? ?? '',
      number: json['number'] as String? ?? '',
      complement: json['complement'] as String?,
      neighborhood: json['neighborhood'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      zipCode: json['zipCode'] as String? ?? '',
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );
  }
}

/// Marina retornada pela API do Estai (`GET /estai-app/marina/:id` e
/// `POST /estai-app/marina-access`).
class Marina {
  final String id;
  final String name;
  final MarinaLocation? location;

  const Marina({required this.id, required this.name, this.location});

  factory Marina.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    return Marina(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      location: location is Map<String, dynamic>
          ? MarinaLocation.fromJson(location)
          : null,
    );
  }

  Map<String, dynamic> toStorageJson() => {'id': id, 'name': name};

  factory Marina.fromStorageJson(Map<String, dynamic> json) {
    return Marina(id: json['id'] as String, name: json['name'] as String);
  }
}
