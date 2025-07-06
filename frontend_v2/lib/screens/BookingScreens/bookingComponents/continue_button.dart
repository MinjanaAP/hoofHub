import 'package:flutter/material.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:provider/provider.dart';

class ContinueButton extends StatelessWidget {
  final bool isEnabled;
  final String? tourId;
  const ContinueButton(
      {super.key, required this.isEnabled, required this.tourId});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton.icon(
          onPressed: isEnabled
              ? () {
                  final bookingProvider =
                      Provider.of<BookingProvider>(context, listen: false);
                  bookingProvider.setRideId(tourId);

                  final bookingData = bookingProvider.data;
                  logger.i("booking Data : ${bookingData.toJson()}");

                  Navigator.pushNamed(context, AppRoutes.dateTimeSelection);
                }
              : null,
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Continue to Booking"),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isEnabled ? const Color(0xFF723594) : Colors.grey[300],
            foregroundColor: isEnabled ? Colors.white : Colors.grey[600],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: isEnabled ? 4 : 0,
          ),
        ),
      ),
    );
  }
}
