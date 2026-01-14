// dart
// Fichier : `lib/components/places_container.dart`
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
      duration: const Duration(milliseconds: 300),
      width: 250,
      height: 175,
      padding: const EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
        color: isOccupied ? const Color(0xFF333333) : const Color(0xFF0066CC),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            blurRadius: 4,
            color: Colors.white.withAlpha(64),
            inset: true,
          ),
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            color: Colors.white.withAlpha(64),
            inset: true,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.hardEdge,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double bottomOffset = constraints.maxHeight * 0.08;
            final bool showAddress = constraints.maxHeight >= 191;
            final bool showIcon = constraints.maxHeight >= 80;

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
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
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Transform.translate(
                                offset: const Offset(0, -10),
                                child: Text(
                                  "Libre",
                                  style: TextStyle(
                                    fontFamily: "Special Gothic Expanded One",
                                    fontSize: 30,
                                    color: isOccupied
                                        ? Colors.white.withAlpha(25)
                                        : Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (showIcon)
                          Expanded(
                            child: Transform.translate(
                              offset: const Offset(0, -15),
                              child: Icon(
                                Icons.fmd_good_outlined,
                                size: 100,
                                color: Colors.white.withAlpha(165),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (showAddress)
                  Positioned(
                    left: 0,
                    right: 10,
                    bottom: bottomOffset,
                    child: Text(
                      address,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
