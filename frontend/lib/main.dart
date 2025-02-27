import 'package:flutter/material.dart';
import 'package:frontend/screens/riderScreens/rider_signup.dart';
import 'package:frontend/screens/starting_page.dart';
import 'screens/home_screen.dart';
import 'screens/landing_page.dart';
import 'package:device_preview/device_preview.dart';
import 'common/bottom_nav_bar.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, //! Set to false in production
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      builder: DevicePreview.appBuilder, // Add this to apply preview settings
      useInheritedMediaQuery: true, // Ensures media queries adapt to preview
      debugShowCheckedModeBanner: false,
      // home:  HomeScreen(),
      home: RiderSignUp(),
    );
  }
}
