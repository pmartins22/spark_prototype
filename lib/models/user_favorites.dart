class Favorite {
  final int favoriteId;
  final int parkingId;
  final String name;
  final String address;

  Favorite({
    required this.favoriteId,
    required this.parkingId,
    required this.name,
    required this.address,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      favoriteId: json['favorite_id'],
      parkingId: json['parking_id'],
      name: json['name'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
    'favorite_id': favoriteId,
    'parking_id': parkingId,
    'name': name,
    'address': address,
  };
}