import 'package:flutter/material.dart';
import 'package:spark_prototype/components/parking_container.dart';
import 'package:spark_prototype/components/spark_bottom_nav_bar.dart';
import 'package:spark_prototype/models/parking.dart';
import 'package:spark_prototype/session/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../map_widget.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<Parking> _favoriteParkings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchParkings();
  }

  Future<void> _fetchParkings() async {
    final user = await AuthService().getUserData();
    setState(() {
      _favoriteParkings = user?.favorites ?? [];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 35, backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: SizedBox(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MapWidget(interactable: false),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, '/map'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Favoris",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      fontSize: 36,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                    ),
                    icon: ImageIcon(
                      AssetImage("assets/icons/right_arrow.png"),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _favoriteParkings.isEmpty
                    ? const Center(child: Text("Aucun favori"))
                    : CarouselView(
                  itemExtent: 250,
                  itemSnapping: true,
                  children: _favoriteParkings
                      .map((p) => ParkingContainer(parking: p))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SparkBottomNavBar(),
    );
  }
}