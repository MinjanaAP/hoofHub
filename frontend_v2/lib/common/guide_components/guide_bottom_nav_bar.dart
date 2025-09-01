import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class GuideBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  const GuideBottomNavBar({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  State<GuideBottomNavBar> createState() => _GuideBottomNavBarState();
}

class _GuideBottomNavBarState extends State<GuideBottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/guideHome');
        break;
      case 1:
        Navigator.pushNamed(context, '/guideRides'); 
        break;
      case 2:
        Navigator.pushNamed(context, '/guideBookingsPage'); 
        break;
      case 3:
        Navigator.pushNamed(context, '/guideSettings');
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
          icon: Icon(Icons.directions_car),
          label: "Rides",
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
