import 'package:flutter/material.dart';
import 'package:spark_prototype/map_widget.dart';


class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<MapWidgetState> _mapKey = GlobalKey<MapWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map U4')),
      body: MapWidget(key: _mapKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapKey.currentState?.centerOnUserLocation();
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
