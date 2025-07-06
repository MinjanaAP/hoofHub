import 'package:flutter/material.dart';
import 'package:frontend/screens/BookingScreens/all_rides_page.dart';
import 'package:frontend/screens/BookingScreens/booking_type_page.dart';
import 'package:frontend/screens/BookingScreens/date_time_selection.dart';
import 'package:frontend/screens/BookingScreens/guide_selection_page.dart';
import 'package:frontend/screens/BookingScreens/waiting_for_guide_page.dart';
import 'package:frontend/screens/guideScreens/guide_home.dart';
import 'package:frontend/screens/guideScreens/guide_login.dart';
import 'package:frontend/screens/guideScreens/guide_page.dart';
import 'package:frontend/screens/guideScreens/guide_signup.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/horseScreens/horse_details_page.dart';

import 'package:frontend/screens/landing_page.dart';
import 'package:frontend/screens/ride_page.dart';
import 'package:frontend/screens/riderScreens/rider_login.dart';
import 'package:frontend/screens/riderScreens/rider_profile.dart';
import 'package:frontend/screens/riderScreens/rider_signup.dart';
import 'package:frontend/screens/select_profile.dart';
import 'package:frontend/screens/starting_page.dart';

class AppRoutes {
  // static const String home = '/';
  //? Rider Routes
  static const String riderLogin = '/riderLogin';
  static const String riderSignUp = '/riderSignUp';
  static const String riderProfile = '/riderProfile';
  static const String riderHome = '/riderHome';

  //? Guide Routes
  static const String guideSignup = '/guideSignup';
  static const String guideLogin = '/guideLogin';
  static const String guidePage = '/guidePage';

  //? Horse routes
  static const String horseDetails = '/horseDetails';

  //? Other Routes
  static const String selectProfile = '/selectProfile';
  static const String startingPage = '/startingPage';
  static const String loadingPage = '/loadingPage';
  static const String guideHome = '/guideHome';
  static const String ridePage = '/ridePage';

  //?Booking Routes
  static const String bookingType = '/bookingType';
  static const String allRides = '/allRides';
  static const String dateTimeSelection = '/dateTimeSelection';
  static const String guideSelection = '/guideSelection';
  static const String waitForGuide = '/waitForGuide';

  static Map<String, WidgetBuilder> routes = {
    //? Initial main home rote
    // home: (context) => const HomeScreen(),

    //? Rider Routes
    riderLogin: (context) => const RiderLoginScreen(),
    riderSignUp: (context) => const RiderSignUp(),
    riderProfile: (context) => RiderProfile(),
    riderHome: (context) => const HomeScreen(),

    //? Guide Routes
    guideSignup: (context) => const GuideSignup(),
    guideLogin: (context) => const GuideLogin(),
    guidePage: (context) => const GuidePage(),
    guideHome: (context) => const GuideHome(),

    //? Horse Routes
    horseDetails: (context) =>
        const HorseDetailPage(horseId: 'DKjUvOC0ZqYwfxUkIYlO'),

    //?Other Routes
    startingPage: (context) => const StartingPage(),
    loadingPage: (context) => const LandingPage(),
    selectProfile: (context) => const SelectProfile(),
    ridePage: (context) => const RidePage(),

    //?Booking Routes
    bookingType: (context) => const BookingTypePage(),
    allRides: (context) => const AllRidesPage(),
    dateTimeSelection: (context) => const DateTimeSelection(),
    guideSelection: (context) => const GuideSelectionPage(),
    waitForGuide: (context) => const WaitingForGuidePage(),
  };
}
