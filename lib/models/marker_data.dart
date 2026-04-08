import 'package:latlong2/latlong.dart';

class MarkerData {
  final String address;
  final LatLng position;
  final bool isTaken;

  const MarkerData({
    required this.address,
    required this.position,
    required this.isTaken,
  });
}