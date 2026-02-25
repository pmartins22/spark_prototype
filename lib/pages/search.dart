import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:spark_prototype/components/places_container.dart';
import 'package:spark_prototype/components/search_page_app_bar.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class Place {
  final bool isOccupied;
  final double lat;
  final double lng;
  final String address;

  Place({
    required this.isOccupied,
    required this.lat,
    required this.lng,
    required this.address,
  });
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<Place> _places = [
    Place(isOccupied: false, lat: 48.8566, lng: 2.3522, address: 'Paris, France'),
    Place(isOccupied: true, lat: 48.8584, lng: 2.2945, address: 'Tour Eiffel, Paris'),
    Place(isOccupied: false, lat: 48.8606, lng: 2.3376, address: 'Louvre, Paris'),
    Place(isOccupied: false, lat: 48.8529, lng: 2.3499, address: 'Île de la Cité, Paris'),
    Place(isOccupied: true, lat: 48.8529, lng: 2.3499, address: 'Île de la Cité, Paris'),
    Place(isOccupied: false, lat: 48.8529, lng: 2.3499, address: 'Île de la Cité, Paris'),
  ];

  bool filterLibreOnly = false;

  @override
  Widget build(BuildContext context) {
    //  Filtre à chaque build pour obtenir la liste des places à afficher
    final List<Place> displayedPlaces = filterLibreOnly
        ? _places.where((place) => !place.isOccupied).toList()
        : _places;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(30.0),
              right: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(64),
                blurRadius: 4.0,
                offset: const Offset(0, -4),
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: SearchPageAppBar(),
                ),
                // Bouton "Libre uniquement"
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        filterLibreOnly = !filterLibreOnly;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        filterLibreOnly ? const Color(0xFF0066CC) : Colors.grey,
                      ),
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Libre uniquement',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: filterLibreOnly ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                // Liste verticale de PlacesContainer
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: displayedPlaces.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final p = displayedPlaces[index];
                      return PlacesContainer(
                        isOccupied: p.isOccupied,
                        address: p.address,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}