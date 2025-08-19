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
  String _searchQuery = '';
  String _selectedLocation = 'All';
  String _selectedDifficulty = 'All';
  String _selectedSort = 'rating';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "hoofHub", showBackButton: true),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              const BookingHeader(
                  title: "Select Your Tour",
                  subtitle: "Explore the best horse riding experiences"),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //? Search Bar
                    _buildSearchBar(),
                    const SizedBox(height: 16),

                    FilterSection(
                      onSortChanged: (sort) {
                        setState(() => _selectedSort = sort);
                      },
                      onLocationChanged: (location) {
                        setState(() => _selectedLocation = location);
                      },
                      onDifficultyChanged: (difficulty) {
                        setState(() => _selectedDifficulty = difficulty);
                      },
                    ),
                    const SizedBox(height: 16),
                    TourCards(
                      selectedTour: selectedTour,
                      onSelect: (id) => setState(() => selectedTour = id),
                      searchQuery: _searchQuery,
                      locationFilter: _selectedLocation,
                      difficultyFilter: _selectedDifficulty,
                      sortBy: _selectedSort,
                      onLoading: (loading) {
                        setState(() => _isLoading = loading);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          ContinueButton(isEnabled: selectedTour != null, tourId: selectedTour),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search rides by name or location...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }
}
