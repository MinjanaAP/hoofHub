import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_nav_bar.dart';
import 'package:frontend/common/home_appbar.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/models/ride_model.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/theme.dart';
import 'package:http/http.dart' as http;

class GuideHome extends StatefulWidget {
  const GuideHome({super.key});
  
  static final User? user = FirebaseAuth.instance.currentUser;

  @override
  State<GuideHome> createState() => _GuideHomeState();
}

class _GuideHomeState extends State<GuideHome> {
  String guideName = 'Guide...';
  String guideImage = 'https://img.freepik.com/free-vector/flat-design-cowboy-silhouette-illustration_23-2149489749.jpg';
  List<Horse> horses = [];
  bool isLoading = true;
  List<Ride> rides = [];
  final Color primaryColor = const Color(0xFF723594);

  @override
  void initState() {
    super.initState();
    fetchGuideData();
    fetchRides();
  }

  Future<void> fetchGuideData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    try {
      final response = await ApiService.getGuideById(user!.uid);
      setState(() {
        guideName = response['fullName'] ?? 'Guide';
        guideImage = response['profileImage'] ?? '';
        horses = [Horse.fromJson(response['horse'])];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Guide Not Found"),
          content: const Text("Please login with correct guide credentials."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.guideLogin),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchRides() async {
    try {
      final response = await http.get(Uri.parse("${ApiConstants.baseUrl}/rides"));
      if (response.statusCode == 200) {
        setState(() {
          rides = (json.decode(response.body) as List)
              .map((json) => Ride.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load rides");
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, AppRoutes.selectProfile);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: ${e.toString()}")),
      );
    }
  }

  void navigateToRideDetail(BuildContext context, Ride ride) {
    Navigator.pushNamed(context, AppRoutes.ridePage, arguments: ride);
  }

  void navigateToHorseDetail(BuildContext context, Horse horse) {
    Navigator.pushNamed(context, AppRoutes.horseDetails , arguments: horse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: const HomeAppBar(),
      drawer: _buildDrawer(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF723594)))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 16),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  _buildHorsesSection(context),
                  const SizedBox(height: 24),
                  _buildBookingsSection(),
                  const SizedBox(height: 24),
                  _buildRideAreasSection(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(guideImage),
                ),
                const SizedBox(height: 12),
                Text(
                  guideName,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  "${GuideHome.user?.email}",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: primaryColor),
            title: const Text('Home'),
            onTap: () => Navigator.pushNamed(context, AppRoutes.guideHome),
          ),
          ListTile(
            leading: Icon(Icons.person, color: primaryColor),
            title: const Text('My Profile'),
            onTap: () => Navigator.pushNamed(context, AppRoutes.guidePage),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: primaryColor),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red[400]),
            title: const Text('Logout'),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, Color(0xFF8f4ab8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(guideImage),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  guideName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your guide dashboard',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _StatCard(
            icon: Icons.calendar_today,
            label: "Today's Rides",
            value: '3',
          )),
          SizedBox(width: 16),
          Expanded(child: _StatCard(
            icon: Icons.star,
            label: "Rating",
            value: '4.8',
          )),
        ],
      ),
    );
  }

  Widget _buildHorsesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Horses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {}, // TODO: Add horse functionality
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 18),
                    SizedBox(width: 4),
                    Text('Add Horse'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...horses.map((horse) => GestureDetector(
            onTap: () => navigateToHorseDetail(context, horse),
            child: _HorseCard(horse: horse),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildBookingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Bookings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...[1, 2].map((e) => const _BookingCard()).toList(),
        ],
      ),
    );
  }

  Widget _buildRideAreasSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Ride Areas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          rides.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      "No rides available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: .77,
                  children: rides.map((ride) => GestureDetector(
                    onTap: () => navigateToRideDetail(context, ride),
                    child: _RideAreaCard(ride: ride),
                  )).toList(),
                ),
        ],
      ),
    );
  }
}

class Horse {
  final String id;
  final String name;
  final String breed;
  final String experience;
  final String image;

  Horse({
    required this.id,
    required this.name,
    required this.breed,
    required this.experience,
    required this.image,
  });

  factory Horse.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? images = json['images'];
    return Horse(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unnamed',
      breed: json['breed'] ?? 'Unknown',
      experience: json['specialNotes'] ?? 'N/A',
      image: (images != null && images.isNotEmpty) ? images[0] : '',
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF723594), size: 24),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorseCard extends StatelessWidget {
  final Horse horse;
  const _HorseCard({required this.horse});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: horse.image.isNotEmpty
                  ? Image.network(
                      horse.image,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 64,
                        height: 64,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image),
                      ),
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    horse.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    horse.breed,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    horse.experience,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde'),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Beginner Rider',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF723594).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(color: Color(0xFF723594)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.calendar_month, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  '2:30 PM - 4:30 PM',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text('Coastal Trail', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RideAreaCard extends StatelessWidget {
  final Ride ride;
  const _RideAreaCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Image.network(
                ride.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        ride.location,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'LKR ${ride.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF723594),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}