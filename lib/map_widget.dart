import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'map/providers/map_location_provider.dart';
import 'map/providers/map_markers_provider.dart';
import 'map/providers/map_viewport_provider.dart';
import 'models/marker_data.dart';

class MapWidget extends ConsumerStatefulWidget {
  final bool interactable;
  final LatLng? initialCenter;

  const MapWidget({super.key, this.interactable = true, this.initialCenter});

  @override
  ConsumerState<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends ConsumerState<MapWidget> {
  final MapController _mapController = MapController();

  double _getMarkerIconSize(double zoom) {
    if (zoom < 14.5) {
      return 0;
    } else if (zoom < 16.0) {
      return 8;
    } else if (zoom < 17.5) {
      return 10;
    } else if (zoom < 19.5) {
      return 12;
    } else {
      return 15;
    }
  }

  void _showMarkerDetails(MarkerData markerData) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 12),
                Text(
                  markerData.address,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              markerData.isTaken ? 'Status: Taken' : 'Status: Available',
              style: TextStyle(
                fontSize: 18,
                color: markerData.isTaken ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _mapController.move(markerData.position, 18.0);
                      ref
                          .read(mapViewportProvider.notifier)
                          .updateFromCamera(markerData.position, 18.0);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.navigation),
                    label: const Text('Navigate'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void centerOnUserLocation() {
    final userPosition = ref.read(mapLocationProvider).value;
    if (userPosition != null) {
      _mapController.move(userPosition, 17.0);
      ref.read(mapViewportProvider.notifier).updateFromCamera(userPosition, 17.0);
    }
  }


  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(mapLocationProvider);
    final viewport = ref.watch(mapViewportProvider);
    final markers = ref.watch(mapMarkersProvider);

    final currentPosition = locationAsync.value;
    final initialCenter = viewport.center ?? currentPosition ?? const LatLng(43.6, 1.44);
    final zoom = viewport.zoom;

    if (locationAsync.isLoading && viewport.center == null) {
      return Hero(
        tag: 'map_hero',
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(32),
                blurRadius: 4.0,
                offset: const Offset(0, -2),
                inset: true,
              ),
              BoxShadow(
                color: Colors.black.withAlpha(32),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
                inset: true,
              ),
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Hero(
      tag: 'map_hero',
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: initialCenter,
          initialZoom: zoom,
          onPositionChanged: (MapCamera position, bool hasGesture) {
            ref
                .read(mapViewportProvider.notifier)
                .updateFromCamera(position.center, position.zoom);
          },
          interactionOptions: InteractionOptions(
            flags: widget.interactable ? InteractiveFlag.all : InteractiveFlag.none,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.spark_prototype',
          ),
          MarkerLayer(
            markers: markers.map((markerData) {
              return Marker(
                point: markerData.position,
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () => _showMarkerDetails(markerData),
                  child: Icon(
                    Icons.circle,
                    color: markerData.isTaken ? Colors.red : Colors.green,
                    size: _getMarkerIconSize(zoom),
                  ),
                ),
              );
            }).toList(),
          ),
          if (currentPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: currentPosition,
                  width: 80,
                  height: 80,
                  child: const Icon(Icons.circle, color: Colors.blue, size: 20),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
