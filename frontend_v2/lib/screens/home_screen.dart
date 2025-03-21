import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_nav_bar.dart';
import 'package:frontend/common/greetin_card.dart';
import 'package:frontend/common/home_appbar.dart';
import 'package:frontend/common/home_carousel.dart';
import 'package:frontend/common/home_search_bar.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/theme.dart';
import 'package:logger/logger.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final logger = Logger();

Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, AppRoutes.selectProfile);
  } catch (e) {
    logger.e("Logout Error : $e");
  }
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
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const HomeAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/profilePic.jpg'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${user?.displayName}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "${user?.email}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_3),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.riderProfile);
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
                logout(context);
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
                // Text(message),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildBookRideCard(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildMostPopularRides(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildPreviousRides(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}


  Widget _buildBookRideCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(Icons.directions, color: Colors.purple[700]),
          ),

          const SizedBox(width: 10),

          // Texts
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Up to 12% Off",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const Text(
                "Book a ride now",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Text(
                "100+ horses",
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.confirmation_num_rounded, color: Colors.purple[700]),
        ],
      ),
    );
  }


Widget _buildMostPopularRides() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Most Popular Rides",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow:const  [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/horse-4.jpg", 
                  width: 120,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gegari Park",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("Nuwara Eliya", style: TextStyle(color: Colors.grey)),
                  Text(
                    "740 m",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                  ),
                  Text(
                    "\$4.99",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Text("30 - 45 mins", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }


Widget _buildPreviousRides() {
    List<Map<String, String>> previousRides = [
      {"name": "ZRI Adventures", "location": "Nuwara Eliya", "date": "14 Feb", },
      {"name": "Makara Resorts Horse Rides", "location": "Nuwara Eliya", "date": "28 Jan"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Previous Rides",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: previousRides.length,
          itemBuilder: (context, index) {
            var ride = previousRides[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange[100],
                  child: const Icon(Icons.location_city),
                ),
                title: Text(
                  ride["name"]!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(ride["location"]!, style: const TextStyle(color: Colors.grey)),
                trailing: Text(ride["date"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          },
        ),
      ],
    );
  }
