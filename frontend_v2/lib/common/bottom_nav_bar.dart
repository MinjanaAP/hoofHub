import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
        // currentIndex: _selectedIndex,
        // onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, 
        backgroundColor: AppColors.primary,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255), // Highlighted item color
        unselectedItemColor: const Color.fromARGB(255, 204, 201, 201), // Unselected item color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_rounded),
            label: "Support",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: "Notification",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      );
  }
}