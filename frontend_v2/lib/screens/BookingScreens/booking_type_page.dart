import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_nav_bar.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/BookingScreens/all_rides_page.dart';
import 'package:frontend/screens/BookingScreens/bookingComponents/continue_button.dart';
import 'package:frontend/screens/BookingScreens/booking_header.dart';
import 'package:frontend/screens/BookingScreens/booking_type_card.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class BookingTypePage extends StatefulWidget {
  const BookingTypePage({super.key});

  @override
  State<BookingTypePage> createState() => _BookingTypePageState();
}

class _BookingTypePageState extends State<BookingTypePage> {
  String? selectedType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "hoofHub",
        showBackButton: true,
      ),
      body: Column(
        children: [
          const BookingHeader(
            title: "Choose Your Ride Type",
            subtitle: "Select the experience that best suits you",
          ),
          const SizedBox(
            height: 28,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BookingTypeCards(
                  selectedType: selectedType,
                  onSelect: (type) {
                    setState(() {
                      selectedType = type;
                    });
                  },
                ),
                const SizedBox(
                  height: 28,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 56.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedType != null
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      shadowColor: selectedType != null
                          ? Colors.black
                          : Colors.transparent,
                      elevation: selectedType != null ? 8 : 0,
                    ),
                    onPressed: selectedType != null
                        ? () {
                            final bookingProvider =
                                Provider.of<BookingProvider>(context,
                                    listen: false);
                            bookingProvider.setRideType(selectedType);
                            Navigator.pushNamed(context, AppRoutes.allRides);
                          }
                        : null,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 250, 250, 250),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
