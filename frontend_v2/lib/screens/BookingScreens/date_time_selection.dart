import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/BookingScreens/bookingComponents/booking_progress_bar.dart';
import 'package:frontend/screens/BookingScreens/bookingComponents/date_selection.dart';
import 'package:frontend/screens/BookingScreens/booking_header.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:provider/provider.dart';

class DateTimeSelection extends StatefulWidget {
  const DateTimeSelection({super.key});

  @override
  State<DateTimeSelection> createState() => _DateTimeSelectionState();
}

class _DateTimeSelectionState extends State<DateTimeSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        title: "hoofHub",
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BookingHeader(
                title: "Select Time For Your Tour",
                subtitle: "Explore the best horse riding experiences.",
              ),
              // SizedBox(height: 20,),
              // const BookingProgressBar(
              //   currentStep: 'date',
              //   steps: ['date', 'payment', 'confirmation'],
              // ),
              DateSelection(
                onBack: () => Navigator.pop(context),
                onNext: () => Navigator.pushNamed(context, AppRoutes.guideSelection),
                onSelect: (date, time) {
                  final bookingProvider =
                      Provider.of<BookingProvider>(context, listen: false);
                  bookingProvider.setDateTime(date, time);
                  logger.i("booking Data: ${bookingProvider.data.toJson()}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
