class Address {
  final int id;
  final String street;
  final String number;
  final String? neighborhood;
  final String city;
  final String? state;
  final String? zipCode;
  final String? country;

  Address({
    required this.id,
    required this.street,
    required this.number,
    this.neighborhood,
    required this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      street: json['street'],
      number: json['number'],
      neighborhood: json['neighborhood'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'street': street,
    'number': number,
    'neighborhood': neighborhood,
    'city': city,
    'state': state,
    'zip_code': zipCode,
    'country': country,
  };
}