import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class SearchPageAppBar extends StatelessWidget {
  const SearchPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(Icons.search, color: Color(0xFF0066CC)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}