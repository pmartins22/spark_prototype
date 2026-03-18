import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../models/marker_data.dart';

final mapMarkersProvider = Provider<List<MarkerData>>((ref) {
  return [
    // Ligne 1 - Cote gauche de la rue.
    MarkerData(
      position: LatLng(43.60958932888868, 1.4312053705860839),
      address: 'Spot A1',
      isTaken: true,
    ),
    MarkerData(
      position: LatLng(43.60961432888868, 1.4312053705860839),
      address: 'Spot A2',
      isTaken: false,
    ),
    MarkerData(
      position: LatLng(43.60963932888868, 1.4312053705860839),
      address: 'Spot A3',
      isTaken: true,
    ),
    MarkerData(
      position: LatLng(43.60966432888868, 1.4312053705860839),
      address: 'Spot A4',
      isTaken: false,
    ),
    MarkerData(
      position: LatLng(43.60968932888868, 1.4312053705860839),
      address: 'Spot A5',
      isTaken: true,
    ),

    // Ligne 2 - Cote droit de la rue.
    MarkerData(
      position: LatLng(43.60959096196893, 1.432046657112799),
      address: 'Spot B1',
      isTaken: false,
    ),
    MarkerData(
      position: LatLng(43.60961596196893, 1.432046657112799),
      address: 'Spot B2',
      isTaken: true,
    ),
    MarkerData(
      position: LatLng(43.60964096196893, 1.432046657112799),
      address: 'Spot B3',
      isTaken: false,
    ),
    MarkerData(
      position: LatLng(43.60966596196893, 1.432046657112799),
      address: 'Spot B4',
      isTaken: true,
    ),
    MarkerData(
      position: LatLng(43.60969096196893, 1.432046657112799),
      address: 'Spot B5',
      isTaken: false,
    ),
  ];
});
