import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';

class SelectProfile extends StatelessWidget {
  const SelectProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //? background image
          Positioned.fill(
            child: Image.asset("assets/images/selectProfileBackImg.png"),
          ),
          //? transparent overlay
          Positioned.fill(
              child: Container(
            color: const Color.fromARGB(22, 114, 53, 148),
          )),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 140, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select your',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        shadows: [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                          )
                        ],
                      ),
                    ),
                    const Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        shadows: [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 94.0,
                    ),
                    const Text(
                      'Choose Your Profile',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(226, 255, 255, 255),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    SizedBox(
                      width: 292.0,
                      height: 48.0,
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.7), // Shadow color
                            blurRadius: 10, // Softness of the shadow
                            offset: const Offset(0, 4),
                          )
                        ]),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(248, 99, 53, 127),
                              foregroundColor: Colors.white,
                              shadowColor: Colors.black,
                              elevation: 8,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.riderLogin
                                  );
                            },
                            child: const Text(
                              'Ride',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 2.0,
                                  color: Color.fromARGB(226, 255, 255, 255)),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 63.0,
                    ),
                    SizedBox(
                      width: 292.0,
                      height: 48.0,
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.7), // Shadow color
                            blurRadius: 10, // Softness of the shadow
                            offset: const Offset(0, 4),
                          )
                        ]),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(248, 99, 53, 127),
                              foregroundColor: Colors.white,
                              shadowColor: Colors.black,
                              elevation: 8,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.guideLogin
                                  );
                            },
                            child: const Text(
                              'Guide',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 2.0,
                                  color: Color.fromARGB(226, 255, 255, 255)),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
