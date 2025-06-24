import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_nav_bar.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/rider_Components/review_item.dart';
import 'package:frontend/common/rider_Components/ride_history_item.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/guideScreens/guide_home.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/theme.dart';
import 'package:logger/web.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});
  static final logger = Logger();

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  String guideName = '';
  String guideImage = 'https://img.freepik.com/free-vector/flat-design-cowboy-silhouette-illustration_23-2149489749.jpg?semt=ais_hybrid&w=740';
  String guideAddress = 'Location...';
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
        guideAddress = response['address'] ?? '';
        horses = [Horse.fromJson(response['horse'])];
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
      GuidePage.logger.e("logout Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        title: "hoofHub",
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.shade400,
                            Colors.purple.shade600
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(guideImage),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 68.0),
                Text(
                  "${user?.displayName}",
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_pin,
                        color: Colors.grey, size: 16),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(guideAddress,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Chip(
                  label: const Text(
                    "Frequent Rider",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
                  ),
                  backgroundColor: Colors.purple.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "4.8",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text("(120 rides)",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                            fontFamily: 'Poppins')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      label: const Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
                      ),
                      icon: const Icon(
                        Icons.edit,
                        color: AppColors.primary,
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.purple),
                      ),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      label: const Text(
                        "Pending Rides",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Ride History",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                  ),
                ),
                const SizedBox(height: 10),
                const RideHistoryItem(
                  title: "Mountain Trail Adventure",
                  date: "Jan 15, 2025",
                  price: "\$85",
                  status: "Completed",
                  statusColor: Colors.green,
                ),
                const RideHistoryItem(
                  title: "Sunset Beach Ride",
                  date: "Jun 23, 2025",
                  price: "\$95",
                  status: "Upcoming",
                  statusColor: Colors.blue,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Reviews",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const ReviewItem(
                  name: "Michael Thompson",
                  review:
                      "Amazing experience! The guide was very knowledgeable and friendly.",
                  timeAgo: "2 days ago",
                  starCount: 5,
                ),
                const ReviewItem(
                  name: "Lisa Anderson",
                  review:
                      "Great trail ride, would definitely recommend to others.",
                  timeAgo: "1 week ago",
                  starCount: 3,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150.0,
                      child: ElevatedButton.icon(
                        label: const Text(
                          "Settings",
                          style: TextStyle(
                              color: Colors.black87, fontFamily: 'Poppins'),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.black87,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150.0,
                      child: ElevatedButton.icon(
                        label: const Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.redAccent, fontFamily: 'Poppins'),
                        ),
                        onPressed: () async {
                          await logout(context);
                        },
                        icon: const Icon(
                          Icons.logout_outlined,
                          color: Colors.redAccent,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
