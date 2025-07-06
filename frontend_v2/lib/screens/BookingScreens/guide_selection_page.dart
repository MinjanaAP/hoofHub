import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/BookingScreens/booking_header.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GuideSelectionPage extends StatefulWidget {
  const GuideSelectionPage({super.key});

  @override
  State<GuideSelectionPage> createState() => _GuideSelectionPageState();
}

class _GuideSelectionPageState extends State<GuideSelectionPage> {
  List<Map<String, dynamic>> _guides = [];
  String? _selectedGuideId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGuides();
  }

  Future<void> fetchGuides() async {
    try {
      final rideId =
          Provider.of<BookingProvider>(context, listen: false).data.rideId;

      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/guides/by-ride/$rideId"),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          _guides = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load guides');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error fetching guides: $e');
    }
  }

  void selectGuide(String guideId) {
    setState(() {
      _selectedGuideId = guideId;
    });
    Provider.of<BookingProvider>(context, listen: false).setGuideId(guideId);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(title: "hoofHub", showBackButton: true),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BookingHeader(
              title: "Select A Guide For Your Tour",
              subtitle: "Explore the best horse riding experiences.",
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const Expanded(
                    child: Center(
                      // child: CircularProgressIndicator()
                      child: SplashScreen(),
                    ),
                  )
                : _guides.isEmpty
                    ? const Expanded(
                        child: Center(
                            child: Text("No guides found for this ride.")),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _guides.length,
                          itemBuilder: (context, index) {
                            final guide = _guides[index];
                            final isSelected = guide['id'] == _selectedGuideId;

                            final guideImage = guide['profileImage'];
                            final horseImage = guide['horse']?['images'][0];

                            return GestureDetector(
                              onTap: () => selectGuide(guide['id']),
                              child: Card(
                                elevation: isSelected ? 6 : 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: isSelected
                                        ? const Color(0xFF723594)
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: guideImage !=
                                                        null &&
                                                    guideImage != ''
                                                ? NetworkImage(guideImage)
                                                : const AssetImage(
                                                        'assets/images/default_user.png')
                                                    as ImageProvider,
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  guide['fullName'] ??
                                                      'Unknown',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  guide['bio'] ??
                                                      'No bio available',
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                          "Experience: ${guide['experience'] ?? 'N/A'}"),
                                      Text(
                                          "Languages: ${guide['languages'] ?? 'N/A'}"),
                                      Text(
                                          "Mobile: ${guide['mobileNumber'] ?? 'N/A'}"),
                                      if (guide['horse'] != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Horse: ${guide['horse']['name']} (${guide['horse']['breed']})",
                                                style: const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                              const SizedBox(height: 8),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: horseImage != null &&
                                                        horseImage != ''
                                                    ? Image.network(
                                                        horseImage,
                                                        height: 150,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : const SizedBox(), // No image fallback
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
      bottomNavigationBar: _selectedGuideId != null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  final bookingProvider =
                      Provider.of<BookingProvider>(context, listen: false);
                  final bookingData = bookingProvider.data;
                  final user = FirebaseAuth.instance.currentUser;

                  // Update UID
                  bookingProvider.setUid(user!.uid);
                  final bookingJson = bookingData.toJson();

                  try {
                    final response = await http.post(
                      Uri.parse("${ApiConstants.baseUrl}/bookings"),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode(bookingJson),
                    );

                    if (response.statusCode == 201) {
                      // Optional: Get booking ID or show a message
                      final result = jsonDecode(response.body);
                      logger.i("Booking created: $result");

                      Navigator.pushNamed(context, AppRoutes.waitForGuide);
                    } else {
                      logger.e("Failed to create booking: ${response.body}");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Failed to create booking")),
                      );
                    }
                  } catch (e) {
                    logger.e("Error: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Something went wrong")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF723594),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }
}
