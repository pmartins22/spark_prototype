import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class SparkBottomNavBar extends StatelessWidget {
  const SparkBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 4.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                Color(0xFF0066CC),
              ),
            ),
            icon: ImageIcon(
              AssetImage("assets/icons/map_pin.png"),
              color: Colors.white,
              size: 15,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 150,
            height: 42,
            child: Container(
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
                child: Icon(Icons.search, color: Color(0xFF0066CC)),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                Color(0xFF0066CC),
              ),
            ),
            icon: ImageIcon(
              AssetImage("assets/icons/user.png"),
              color: Colors.white,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}
