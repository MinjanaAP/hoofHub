import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class HomeSearchBar extends StatelessWidget {
  HomeSearchBar({super.key});
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(41, 188, 186, 186),
        borderRadius: BorderRadius.circular(30.0), 
        border: Border.all(
            color: Colors.white.withOpacity(0.5)), 
      ),
      child: TextField(
        controller: searchController,
        style:  TextStyle(color: Color.fromARGB(33, 0, 0, 0).withOpacity(0.7)), // Text color
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(
              color: const Color.fromARGB(33, 0, 0, 0).withOpacity(0.7)), // Transparent hint text
          prefixIcon:
              const Icon(Icons.search, color: Color.fromARGB(159, 0, 0, 0)), // Search icon
          border: InputBorder.none, // Removes default border
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
