import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class MapViewportState {
  final LatLng? center;
  final double zoom;

  const MapViewportState({this.center, this.zoom = 15.0});

  MapViewportState copyWith({LatLng? center, double? zoom}) {
    return MapViewportState(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
    );
  }
}

class MapViewportNotifier extends Notifier<MapViewportState> {
  @override
  MapViewportState build() => const MapViewportState();

  void updateFromCamera(LatLng center, double zoom) {
    state = state.copyWith(center: center, zoom: zoom);
  }
}

final mapViewportProvider =
    NotifierProvider<MapViewportNotifier, MapViewportState>(
      MapViewportNotifier.new,
    );

