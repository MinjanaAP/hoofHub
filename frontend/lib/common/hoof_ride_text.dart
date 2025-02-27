import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class HoofHubText extends StatelessWidget {
  const HoofHubText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "hoof",
            style: TextStyle(
              fontSize: 34.0,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
              fontFamily: 'Poppins',
              shadows: [
                  Shadow(
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    color: Color.fromRGBO(0, 0, 0, 0.25)
                  )
                ]
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              "Ride.",
              style: TextStyle(
                fontSize: 34.0,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                fontFamily: 'Poppins',
                shadows: [
                  Shadow(
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    color: Color.fromRGBO(0, 0, 0, 0.25)
                  )
                ]
              ),
            ),
          ),
        ]
      ),
    );
  }
}