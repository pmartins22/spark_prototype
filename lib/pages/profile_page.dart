import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:spark_prototype/components/parking_container.dart';
import 'package:spark_prototype/components/profile_page_app_bar.dart';
import 'package:spark_prototype/map_screen.dart';
import 'package:spark_prototype/models/user_addresses.dart';
import '../map_widget.dart';
import '../models/user.dart';
import '../session/auth_service.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  LatLng? _userMainAddressLocation;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    User? user = await _fetchUserData();
    LatLng? location = await getLatLng(user);

    setState(() {
      _user = user;
      _userMainAddressLocation = location;
    });
  }

  Future<User?> _fetchUserData() async {
    final user = await AuthService().getUserData();
    return user;
  }

  Future<LatLng?> getLatLng(User? user) async {
    if (user == null || user.mainAddress == null) return null;
    Address mainAddress = user.mainAddress!;

    String address = "${mainAddress.street}, ${mainAddress.number}, ${mainAddress.city}";

    final locations = await locationFromAddress(address);
    if (locations.isEmpty) return null;
    return LatLng(locations.first.latitude, locations.first.longitude);
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
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.transparent,
                backgroundImage: _user?.picture != null
                    ? MemoryImage(_user!.picture!)
                    : const AssetImage("assets/profile_frame.png") as ImageProvider,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(color: Colors.grey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Address",
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
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MapWidget(
                        key: ValueKey(_userMainAddressLocation),
                        interactable: false,
                        initialCenter: _userMainAddressLocation,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MapScreen(initialCenter: _userMainAddressLocation,)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Favorites",
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
                    ? const Center(child: Text("No favorites yet"))
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