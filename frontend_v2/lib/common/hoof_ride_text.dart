import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class HoofHubText extends StatelessWidget {
  final String text;
  const HoofHubText({
    Key ? key,
    required this.text
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
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
                        color: Color.fromRGBO(0, 0, 0, 0.25))
                  ]),
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                    shadows: [
                      Shadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Color.fromRGBO(0, 0, 0, 0.385))
                    ]),
              ),
            ),
          ]),
    );
  }
}
