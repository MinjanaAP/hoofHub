import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_nav_bar.dart';
import 'package:frontend/common/greetin_card.dart';
import 'package:frontend/common/home_appbar.dart';
import 'package:frontend/common/home_carousel.dart';
import 'package:frontend/common/home_search_bar.dart';
import 'package:frontend/theme.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String message = "Fetching data...";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final data = await ApiService.getData();
    setState(() {
      message = data ?? "Failed to fetch data";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const HomeAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "User Name",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "user@example.com",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_3),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const GreetingCard(),
                HomeCarousel(),
                HomeSearchBar(),
                Text(message),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
