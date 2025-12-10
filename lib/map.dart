import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'models/marker_data.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition;
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLoading = true;

  final List<MarkerData> _markers = [
    MarkerData(
      position: LatLng(43.60958932888868, 1.4312053705860839),
      address: 'Marker 1',
      isTaken: true,
    ),
    MarkerData(
      position: LatLng(43.60959096196893, 1.432046657112799),
      address: 'Marker 2',
      isTaken: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
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

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map U4')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition ?? LatLng(43.6, 1.44),
                initialZoom: 15.0,
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
                          color: Colors.purple,
                          size: 15,
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentPosition != null) {
            _mapController.move(_currentPosition!, 17.0);
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
