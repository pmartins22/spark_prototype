import 'package:flutter/material.dart';
import 'package:spark_prototype/components/parking_container.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    final user = await AuthService().getUserData();
    setState(() => _user = user);
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
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Image(image: AssetImage("assets/profile_frame.png")),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(color: Colors.grey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
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
                  const Text(
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
                child: _user == null
                    ? const Center(child: CircularProgressIndicator())
                    : _user!.favorites.isEmpty
                    ? const Center(child: Text("Aucun favori"))
                    : CarouselView(
                  itemExtent: 250,
                  itemSnapping: true,
                  children: _user!.favorites
                      .map((p) => ParkingContainer(parking: p))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}