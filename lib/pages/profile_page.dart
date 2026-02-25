import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:spark_prototype/components/places_container.dart';
import 'package:spark_prototype/components/profile_page_app_bar.dart';

import '../models/user.dart';
import '../session/auth_service.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  List<PlacesContainer>? _favoritePlaces;

  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    final authService = AuthService();
    final token = await authService.getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _user = User.fromJson(data);
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
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
                _user != null ? _user!.username : "Loading...",
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
                  children: _favoritePlaces ?? [Center(child: Text("Loading..."))],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
