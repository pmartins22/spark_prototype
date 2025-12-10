import 'package:flutter/material.dart';
import 'package:spark_prototype/components/places_container.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: PlacesContainer(isOccupied: false, address: 'Rue Test, 01000 Ville',)
      ),
    );
  }
}
