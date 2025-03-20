import 'package:flutter/material.dart';
import 'package:frontend/screens/landing_page.dart';
import 'package:frontend/screens/riderScreens/rider_login.dart';
import 'package:frontend/screens/riderScreens/rider_profile.dart';
import 'package:frontend/screens/riderScreens/rider_signup.dart';
import 'package:frontend/screens/select_profile.dart';
import 'package:frontend/screens/starting_page.dart';
import '../screens/home_screen.dart';

class AppRoutes {
  // static const String home = '/';

  //? Rider Routes
  static const String riderLogin = '/riderLogin';
  static const String riderSignUp = '/riderSignUp';
  static const String riderProfile = '/riderProfile';

  //? Other Routes
  static const String selectProfile = '/selectProfile';
  static const String startingPage = '/startingPage';
  static const String loadingPage = '/loadingPage';

  static Map<String, WidgetBuilder> routes = {
    //? Initial main home rote
    // home: (context) => const HomeScreen(),

    //? Rider Routes
    riderLogin: (context) => const RiderLoginScreen(),
    riderSignUp: (context) => const RiderSignUp(),
    riderProfile: (context) => RiderProfile(),

    //?Other Routes
    startingPage: (context) => const StartingPage(),
    loadingPage: (context) => const LandingPage(),
    selectProfile: (context) => const SelectProfile(),
  };
}
