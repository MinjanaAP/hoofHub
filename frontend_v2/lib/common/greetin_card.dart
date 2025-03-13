import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Hi",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          shadows: [
                            Shadow(
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                color: Color.fromRGBO(0, 0, 0, 0.25))
                          ]),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Good Morning.",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(78, 114, 53, 148),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      "Rider",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          shadows: [
                            Shadow(
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                color: Color.fromRGBO(0, 0, 0, 0.25))
                          ]),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "John Doe",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                          color: AppColors.primary,
                          shadows: [
                            Shadow(
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                color: Color.fromRGBO(0, 0, 0, 0.25))
                          ]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 16.0),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEDE4F8),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(88.0),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image.asset('assets/images/silver_badge.png',
                          fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 8.0,),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Silver",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Text("Rider",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}