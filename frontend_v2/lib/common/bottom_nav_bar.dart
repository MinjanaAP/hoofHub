import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // Map index to route names or page navigation
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; 

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/allRides');
        break;
      case 1:
        Navigator.pushNamed(context, '/allRides');
        break;
      case 2:
        Navigator.pushNamed(context, '/riderBookings');
        break;
      case 3:
        Navigator.pushNamed(context, '/allRides');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color.fromARGB(255, 204, 201, 201),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notification_add),
          label: "Notification",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airplane_ticket),
          label: "Bookings",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}
