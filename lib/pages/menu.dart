import 'package:flutter/material.dart';
import 'package:spark_prototype/components/places_container.dart';
import 'package:spark_prototype/components/spark_bottom_nav_bar.dart';

import '../map_widget.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 35, backgroundColor: Colors.white,),
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
                      MapWidget(
                        interactable: false,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            print("Navigating to map page");
                            Navigator.pushNamed(context, '/map');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
              ,
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
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.black,
                      ),
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
      bottomNavigationBar: SparkBottomNavBar(),
    );
  }
}
