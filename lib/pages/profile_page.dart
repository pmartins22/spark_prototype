import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spark_prototype/components/places_container.dart';
import 'package:spark_prototype/components/profile_page_app_bar.dart';

class ProfilePage extends StatefulWidget {
  final String nickname = "User123";
  final List<PlacesContainer> favoritePlaces = List<PlacesContainer>.empty(
    growable: true,
  );

  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String get _nickname => widget.nickname;

  List<Widget> _buildTestListForCarousel() {
    return List.generate(5, (index) {
      return PlacesContainer(
        isOccupied: false,
        address: "Rue Test, 01000 Ville",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfilePageAppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _nickname,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image(image: AssetImage("assets/profile_frame.png")),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(color: Colors.grey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Domicile",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  ImageIcon(AssetImage("assets/icons/house.png"), size: 30),
                ],
              ),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: GestureDetector(onTap: () {}),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Récents",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  ImageIcon(AssetImage("assets/icons/recents.png"), size: 30),
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 180,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: CarouselView(
                  itemExtent: 250,
                  itemSnapping: true,
                  children: _buildTestListForCarousel(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
