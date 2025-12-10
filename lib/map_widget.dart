import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'models/marker_data.dart';

class MapWidget extends StatefulWidget {
  final bool interactable;

  const MapWidget({super.key, this.interactable = true});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  LatLng? _currentPosition;
  double _currentZoom = 15.0;
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLoading = true;

  final List<MarkerData> _markers = [
    // Linha 1 - Lado esquerdo da rua
    MarkerData(
      position: LatLng(43.60958932888868, 1.4312053705860839),
      address: 'Spot A1',
      isTaken: true,
    ),
    MarkerData(
      position: LatLng(43.60961432888868, 1.4312053705860839), // ~2.5m ao norte
      address: 'Spot A2',
      isTaken: false,
    ),
    MarkerData(
      position: LatLng(43.60963932888868, 1.4312053705860839), // ~2.5m ao norte
      address: 'Spot A3',
      isTaken: true,
    ),
    MarkerData(
      position: LatLng(43.60966432888868, 1.4312053705860839), // ~2.5m ao norte
      address: 'Spot A4',
      isTaken: false,
    ),
    MarkerData(
      position: LatLng(43.60968932888868, 1.4312053705860839), // ~2.5m ao norte
      address: 'Spot A5',
      isTaken: true,
    ),

    // Linha 2 - Lado direito da rua (paralela)
    MarkerData(
      position: LatLng(43.60959096196893, 1.432046657112799),
      address: 'Spot B1',
      isTaken: false,
    ),
    MarkerData(
      position: LatLng(43.60961596196893, 1.432046657112799), // ~2.5m ao norte
      address: 'Spot B2',
      isTaken: true,
    ),
    MarkerData(
      position: LatLng(43.60964096196893, 1.432046657112799), // ~2.5m ao norte
      address: 'Spot B3',
      isTaken: false,
    ),
    MarkerData(
      position: LatLng(43.60966596196893, 1.432046657112799), // ~2.5m ao norte
      address: 'Spot B4',
      isTaken: true,
    ),
    MarkerData(
      position: LatLng(43.60969096196893, 1.432046657112799), // ~2.5m ao norte
      address: 'Spot B5',
      isTaken: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });

    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((Position position) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
          });
        });
  }

  double _getMarkerIconSize() {
    if (_currentZoom < 14.5) {
      return 0;
    } else if (_currentZoom >= 14.5 && _currentZoom < 16.0) {
      return 8;
    } else if (_currentZoom >= 16.0 && _currentZoom < 17.5) {
      return 10;
    } else if (_currentZoom >= 17.5 && _currentZoom < 19.5){
      return 12;
    } else {
      return 15;
    }
  }

  void _showMarkerDetails(MarkerData markerData) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 12),
                Text(
                  markerData.address,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              markerData.isTaken ? 'Status: Taken' : 'Status: Available',
              style: TextStyle(
                fontSize: 18,
                color: markerData.isTaken ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _mapController.move(markerData.position, 18.0);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.navigation),
                    label: Text('Navigate'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                    label: Text('Close'),
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
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 17.0);
    }
  }


  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentPosition ?? LatLng(43.6, 1.44),
        initialZoom: 15.0,
        onPositionChanged: (MapCamera position, bool hasGesture) {
          setState(() {
            _currentZoom = position.zoom;
          });
        },
          interactionOptions: InteractionOptions(
            flags: widget.interactable ? InteractiveFlag.all : InteractiveFlag.none
          )
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.spark_prototype',
        ),
        MarkerLayer(
          markers: _markers.map((markerData) {
            return Marker(
              point: markerData.position,
              width: 80,
              height: 80,
              child: GestureDetector(
                child: Icon(
                  Icons.circle,
                  color: markerData.isTaken ? Colors.red : Colors.green,
                  size: _getMarkerIconSize(),
                ),
                onTap: () => _showMarkerDetails(markerData),
              ),
            );
          }).toList(),
        ),
        if (_currentPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _currentPosition!,
                width: 80,
                height: 80,
                child: Icon(Icons.circle, color: Colors.blue, size: 20),
              ),
            ],
          ),
      ],
    );
  }
}
