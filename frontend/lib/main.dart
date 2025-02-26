import 'package:flutter/material.dart';
import 'package:frontend/screens/starting_page.dart';
import 'screens/home_screen.dart';
import 'screens/landing_page.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, //! Set to false in production
      builder: (context) =>  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder, // Add this to apply preview settings
      useInheritedMediaQuery: true, // Ensures media queries adapt to preview
      debugShowCheckedModeBanner: false,
      home:  HomeScreen(),
    );
  }
}
