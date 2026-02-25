import 'package:flutter/material.dart';
import 'package:spark_prototype/map_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<MapWidgetState> _mapKey = GlobalKey<MapWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: ClipRect(
          clipBehavior: Clip.antiAlias,
          child: FilledButton.icon(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                Color(0xFF45A2FF),
              ),
            ),
            onPressed: () => Navigator.of(context).pop,
            label: Text("Going Back"),
            icon: ImageIcon(
              AssetImage("assets/icons/right_arrow.png"),
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: MapWidget(key: _mapKey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF45A2FF),
        foregroundColor: Color(0xFF00316C),
        onPressed: () {
          _mapKey.currentState?.centerOnUserLocation();
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
