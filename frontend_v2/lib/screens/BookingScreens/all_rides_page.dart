import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_nav_bar.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/screens/BookingScreens/bookingComponents/continue_button.dart';
import 'package:frontend/screens/BookingScreens/bookingComponents/filter_section.dart';
import 'package:frontend/screens/BookingScreens/bookingComponents/tour_cards.dart';
import 'package:frontend/screens/BookingScreens/booking_header.dart';

class AllRidesPage extends StatefulWidget {
  const AllRidesPage({super.key});

  @override
  State<AllRidesPage> createState() => _AllRidesPageState();
}

class _AllRidesPageState extends State<AllRidesPage> {
  String? selectedTour;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "hoofHub", showBackButton: true,),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              const BookingHeader(title: "Select Your Tour", subtitle: "Explore the best horse riding experiences ."),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    const FilterSection(),
                    const SizedBox(height: 16),
                    TourCards(
                      selectedTour: selectedTour,
                      onSelect: (id) => setState(() => selectedTour = id),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ContinueButton(isEnabled: selectedTour != null, tourId: selectedTour),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
