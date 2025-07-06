import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/BookingScreens/bookingComponents/booking_progress_bar.dart';
import 'package:frontend/screens/BookingScreens/bookingComponents/date_selection.dart';
import 'package:frontend/screens/BookingScreens/booking_header.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:provider/provider.dart';

class DateSelectionPage extends StatefulWidget {
  const DateSelectionPage({super.key});

  @override
  State<DateSelectionPage> createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends State<DateSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        title: "hoofHub",
        showBackButton: true,
      ),
      body: Column(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingHeader(
                title: "Select Time For Your Tour",
                subtitle: "Explore the best horse riding experiences.",
              ),
              SizedBox(height: 18),
              BookingProgressBar(
                currentStep: 'date',
                steps: ['Date & Time', 'Payments', 'Confirmation'],
              ),
              SizedBox(height: 18),
            ],
          ),
          // Expanded content section with scrolling
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DateSelection(
                onBack: () => Navigator.pop(context),
                onNext: () =>
                    Navigator.pushNamed(context, AppRoutes.allRides),
                onSelect: (date, time) {
                  final bookingProvider =
                      Provider.of<BookingProvider>(context, listen: false);
                  bookingProvider.setDateTime(date, time);
                  logger.i("booking Data: ${bookingProvider.data.toJson()}");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}