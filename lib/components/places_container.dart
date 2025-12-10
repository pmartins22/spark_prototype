import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class PlacesContainer extends StatelessWidget {
  final bool isOccupied;
  final String address;

  const PlacesContainer({
    super.key,
    required this.isOccupied,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 250,
      height: 150,
      padding: EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
        color: isOccupied ? Color(0xFF333333) : Color(0xFF0066CC),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -4),
            blurRadius: 4,
            color: Colors.white.withAlpha(64),
            inset: true,
          ),
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: Colors.white.withAlpha(64),
            inset: true,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Occupée",
                        style: TextStyle(
                          fontFamily: "Special Gothic Expanded One",
                          fontSize: 30,
                          color: isOccupied
                              ? Colors.white
                              : Colors.white.withAlpha(25),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -10),
                        child: Text(
                          "Libre",
                          style: TextStyle(
                            fontFamily: "Special Gothic Expanded One",
                            fontSize: 30,
                            color: isOccupied
                                ? Colors.white.withAlpha(25)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Transform.translate(
                    offset: Offset(4, -10),
                    child: Icon(
                      Icons.fmd_good_outlined,
                      size: 110,
                      color: Colors.white.withAlpha(165),
                      shadows: [
                        BoxShadow(
                          offset: Offset(0, -4),
                          blurRadius: 4,
                          color: Colors.black.withAlpha(64),
                          inset: true,
                        ),
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Colors.black.withAlpha(64),
                          inset: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              address,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
