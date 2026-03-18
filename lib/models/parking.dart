import 'package:spark_prototype/models/spot.dart';

class Parking {
  final int id;
  final String name;
  final String? address;
  final List<Spot> spots;

  Parking({
    required this.id,
    required this.name,
    this.address,
    this.spots = const [],
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      spots: (json['spots'] as List<dynamic>?)
          ?.map((s) => Spot.fromJson(s))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'spots': spots.map((s) => s.toJson()).toList(),
  };
}