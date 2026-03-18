class Spot {
  final int id;
  final int parkingId;
  final double? lat;
  final double? lng;
  final String state; // 'free', 'taken', 'no_connection'

  Spot({
    required this.id,
    required this.parkingId,
    this.lat,
    this.lng,
    this.state = 'no_connection',
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: json['id'],
      parkingId: json['parking_id'],
      lat: json['lat'] != null ? double.parse(json['lat'].toString()) : null,
      lng: json['lng'] != null ? double.parse(json['lng'].toString()) : null,
      state: json['state'] ?? 'no_connection',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'parking_id': parkingId,
    'lat': lat,
    'lng': lng,
    'state': state,
  };
}