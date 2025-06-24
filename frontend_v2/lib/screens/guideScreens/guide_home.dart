import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/common/bottom_nav_bar.dart';
import 'package:frontend/common/home_appbar.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/theme.dart';
import 'package:logger/web.dart';

class GuideHome extends StatefulWidget {


  const GuideHome({
    super.key,
  });
  static final User? user = FirebaseAuth.instance.currentUser;
  @override
  State<GuideHome> createState() => _GuideHomeState();
}

class _GuideHomeState extends State<GuideHome> {
  String guideName = 'Guide...';
  String guideImage = 'https://img.freepik.com/free-vector/flat-design-cowboy-silhouette-illustration_23-2149489749.jpg?semt=ais_hybrid&w=740';
  List<Horse> horses = [];
  bool isLoading = true;

  static final logger = Logger();
  static final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchGuideData();
  }

  Future<void> fetchGuideData() async {
    if (user == null) return;
    logger.i("uid : ${user?.uid}");
    try {
      final response = await ApiService.getGuideById(user!.uid);
      logger.i("response : $response");
      setState(() {
        guideName = response['fullName'] ?? 'Guide';
        guideImage = response['profileImage'] ?? '';
        horses = [
          Horse.fromJson(response['horse'])
        ];
        isLoading = false;
      });
    } catch (e) {
      logger.e("Guide Fetch Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, AppRoutes.selectProfile);
    } catch (e) {
      logger.e("Logout Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
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
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(guideImage),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    guideName,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "${GuideHome.user?.email}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.guideHome);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_3),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.guidePage);
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF723594), Color(0xFF8f4ab8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(guideImage),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        guideName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Your dashboard overview',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Stats
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _StatCard(
                    icon: Icons.calendar_today,
                    label: "Today's Rides",
                    value: '3',
                  ),
                  const SizedBox(width: 16),
                  _StatCard(
                    icon: Icons.star,
                    label: "Rating",
                    value: '4.8',
                  ),
                ],
              ),
            ),

            // My Horses
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Horses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.plus_one, color: Color(0xFF723594)),
                    label: const Text(
                      'Add Horse',
                      style: TextStyle(color: Color(0xFF723594)),
                    ),
                  )
                ],
              ),
            ),
            ...horses.map((horse) => _HorseCard(horse: horse)).toList(),

            // Upcoming Bookings (hardcoded)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Upcoming Bookings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...[1, 2].map((e) => _BookingCard()),

            // Ride Areas (hardcoded)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Available Ride Areas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  'Coastal Trail',
                  'Mountain Path',
                  'Forest Track',
                  'Beach Route'
                ].map((area) => _RideAreaCard(areaName: area)).toList(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class Horse {
  final String name;
  final String breed;
  final String experience;
  final String image; 

  Horse({
    required this.name,
    required this.breed,
    required this.experience,
    required this.image,
  });

  factory Horse.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? images = json['images'];
    return Horse(
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

  const _StatCard(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(icon, color: Color(0xFF723594), size: 20),
                  const SizedBox(width: 8),
                  Text(label, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold))
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        child: ListTile(
          leading: horse.image.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(horse.image,
                      width: 56, height: 56, fit: BoxFit.cover),
                )
              : const Icon(Icons.image),
          title: Text(horse.name),
          subtitle: Text('${horse.breed}\n${horse.experience} Level'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=50&h=50'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('John Doe',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Beginner Rider',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF723594).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(color: Color(0xFF723594)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.calendar_month, size: 16, color: Colors.grey),
                  SizedBox(width: 6),
                  Text('2:30 PM - 4:30 PM',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.location_city, size: 16, color: Colors.grey),
                  SizedBox(width: 6),
                  Text('Coastal Trail', style: TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _RideAreaCard extends StatelessWidget {
  final String areaName;
  const _RideAreaCard({required this.areaName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: Card(
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                'https://images.unsplash.com/photo-1586947250822-31a4f10f0d72?auto=format&fit=crop&q=80&w=200',
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(areaName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text('2.5 km', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
