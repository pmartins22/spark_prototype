import 'package:flutter/material.dart';
import 'package:spark_prototype/components/places_container.dart';
import 'package:spark_prototype/components/search_page_app_bar.dart';

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

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Exemple de données mock — remplace par ta source réelle
  final List<Place> _places = [
    Place(isOccupied: false, lat: 48.8566, lng: 2.3522, address: 'Paris, France'),
    Place(isOccupied: true, lat: 48.8584, lng: 2.2945, address: 'Tour Eiffel, Paris'),
    Place(isOccupied: false, lat: 48.8606, lng: 2.3376, address: 'Louvre, Paris'),
    Place(isOccupied: false, lat: 48.8529, lng: 2.3499, address: 'Île de la Cité, Paris'),
    Place(isOccupied: true, lat: 48.8529, lng: 2.3499, address: 'Île de la Cité, Paris'),
    Place(isOccupied: false, lat: 48.8529, lng: 2.3499, address: 'Île de la Cité, Paris'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(30.0), right: Radius.circular(30.0)),
            boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 4.0,
            offset: const Offset(0, -4),
          ),
        ],
        color: Colors.white
      ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: SearchPageAppBar(),
                ),
            
                // Titre ou instruction
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Places disponibles',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
            
                // Liste verticale de PlacesContainer
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: _places.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final p = _places[index];
                      return PlacesContainer(
                        isOccupied: p.isOccupied,
                        address: p.address,
                      );
                    },
                  ),
                ),
            
                // Optionnel : afficher une liste verticale supplémentaire ou détails
                const SizedBox(height: 16),
                Text('${_places.length} places trouvées'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
