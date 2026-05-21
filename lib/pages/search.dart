import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:spark_prototype/components/parking_container.dart';
import 'package:spark_prototype/models/parking.dart';
import 'package:spark_prototype/session/auth_service.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Parking> _allParkings = [];
  List<Parking> _filteredParkings = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchParkings();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredParkings = _allParkings
          .where((p) => p.name.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _fetchParkings() async {
    final token = await AuthService().getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/parkings'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _allParkings = data.map((p) => Parking.fromJson(p)).toList();
          _filteredParkings = _allParkings;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Container(
                    height: 65,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFF0066CC),
                            ),
                          ),
                          icon: const ImageIcon(
                            AssetImage("assets/icons/left_arrow.png"),
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
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
                            ),
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.search, color: Color(0xFF0066CC)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      style: const TextStyle(fontFamily: 'Poppins'),
                                      decoration: const InputDecoration(
                                        hintText: 'Rechercher...',
                                        hintStyle: TextStyle(fontFamily: 'Poppins'),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredParkings.isEmpty
                      ? const Center(child: Text("Aucun parking trouvé"))
                      : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: _filteredParkings.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return ParkingContainer(
                        parking: _filteredParkings[index],
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