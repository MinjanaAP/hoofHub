import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/BookingScreens/booking_header.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WaitingForGuidePage extends StatefulWidget {
  const WaitingForGuidePage({super.key});

  @override
  State<WaitingForGuidePage> createState() => _WaitingForGuidePageState();
}

class _WaitingForGuidePageState extends State<WaitingForGuidePage> {
  @override
  void initState() {
    super.initState();

    // Simulate a delay before checking confirmation (15 seconds her
    Timer(const Duration(seconds: 15), () {
      // Clear booking data
      Provider.of<BookingProvider>(context, listen: false).reset();

      // Navigate to allRides and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "hoofhub",
        showBackButton: true,
      ),
      backgroundColor: const Color(0xFFF9F7FB),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const BookingHeader(
                  title: "Waiting for Guide Confirmation",
                  subtitle: "Explore the best horse riding experiences."),
              const SizedBox(
                height: 48,
              ),
              Lottie.asset(
                'assets/animations/horse_waiting.json',
                height: 250,
                width: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                child: Text(
                  "Waiting for Guide Confirmation...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF723594),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                child: Text(
                  "We've sent your booking request to the selected guide. Hang tight while they confirm the ride!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
