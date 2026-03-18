import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapLocationNotifier extends AsyncNotifier<LatLng?> {
  StreamSubscription<Position>? _positionSubscription;

  @override
  Future<LatLng?> build() async {
    ref.onDispose(() {
      _positionSubscription?.cancel();
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    final currentPosition = await Geolocator.getCurrentPosition();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((position) {
      state = AsyncData(LatLng(position.latitude, position.longitude));
    });

    return LatLng(currentPosition.latitude, currentPosition.longitude);
  }
}

final mapLocationProvider =
    AsyncNotifierProvider<MapLocationNotifier, LatLng?>(
      MapLocationNotifier.new,
    );

