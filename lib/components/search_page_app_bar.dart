import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class SearchPageAppBar extends StatelessWidget {
  const SearchPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                Color(0xFF0066CC),
              ),
            ),
            icon: ImageIcon(
              AssetImage("assets/icons/right_arrow.png"),
              color: Colors.white,
              size: 15,
            ),
          ),
          Expanded(  
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
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
            
              ),
            ),
          ),
        ],
      ),
    );
  }
}