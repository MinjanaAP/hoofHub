import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/skeletons/custom_loading_page.dart';
import 'package:frontend/services/ride_service.dart';

class RidePage extends StatefulWidget {
  // static final ride = Ride(
  //     title: "Sunset Beach Ride",
  //     description: "Enjoy a scenic horseback ride along the golden shores.",
  //     location: "Arugam Bay",
  //     duration: "2 hours",
  //     distance: "5.2 KM",
  //     price: 49.99,
  //     rating: 4.8,
  //     reviews: 112,
  //     image:
  //         "https://horseandrider.com/wp-content/uploads/migrations/horseandrider/Horse-rider-driver-blogmay119.jpg",
  //     includes: ["Helmet", "Instructor", "Water", "Insurance"],
  //     maxParticipants: 8,
  //     specifications: {
  //       "ageLimit": "12+",
  //       "difficulty": "Easy",
  //       "language": "English"
  //     },
  //     expect:
  //         "Explore colonial tea estate and Central hills of Sri Lanka in Little England while riding a horse. This incorporates the Village ride. Nuwara Eliya is currently the horse capital of the island, with the only remaining Race Course.",
  //     route: {
  //       "start": "Gegary Park, Nuwara Eliya, Sri Lanka.",
  //       "end": "This activity ends back at the meeting point"
  //     },
  //     additionalInfo: [
  //       "Confirmation will be received at time of booking.",
  //       "Not recommended for travellers with back problems.",
  //       "Not recommended for pregnant travellers",
  //       "No heart problems or other serious medical conditions"
  //     ],
  //     cancelPolicy:
  //         "For a full refund, cancel at least 24 hours in advance of the start date of the experience.",
  //     contact: "+1 855 275 5071");

  const RidePage({super.key});

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  late Future<Map<String, dynamic>> ride;
  late String rideId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      rideId = args;
      ride = RideService().getRideById(rideId);
      logger.i('ride === : $ride : $rideId');
    } else {
      throw Exception("No ride ID passed to RidePage");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CustomAppBar(
        title: "hoofHub",
        showBackButton: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ride,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Center(child: CircularProgressIndicator());
            return const CustomLoadingScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No ride data found"));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Hero Image + Overlay
                Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      child: Image.network(
                        data['images'][0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 24,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.map_outlined,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(data['location'],
                                  style: const TextStyle(color: Colors.white)),
                              const SizedBox(width: 12),
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "${data['rating']} (${data['reviews']} reviews)",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Body Content
                _buildBody(data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price and Book
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rs. ${data['price']}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text("per person",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF723594),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Book Now",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),

                const Divider(height: 32),

                // Specifications
                const Text("Specifications",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconText(Icons.people, "Max ${data['maxParticipants']}",
                        "Group Size"),
                    _iconText(Icons.lock_clock, data['duration'], "Duration"),
                    _iconText(
                        Icons.route_rounded, data['distance'], "Distance"),
                    _iconText(Icons.person, data['specifications']['ageLimit'],
                        "Age Limit"),
                  ],
                ),

                const Divider(height: 32),

                // Description
                const Text("About the Ride",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(data['description'],
                    style: const TextStyle(color: Colors.grey)),

                const Divider(height: 32),

                // Includes
                const Text("What's Included",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                ...List.from(data['includes']).map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF723594).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.shield,
                                size: 18, color: Color(0xFF723594)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),

        // Extra Sections (Expect, Route, Additional Info, Cancel Policy, Contact)
        _extraInfoSection(data),
      ],
    );
  }

  Widget _extraInfoSection(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What to expect",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(data['expect'], style: const TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            const Text("Route Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _detailRow(
                Icons.location_on, "Start Point", data['route']['start']),
            const SizedBox(height: 8),
            _detailRow(Icons.flag, "End Point", data['route']['end']),
            const Divider(height: 32),
            const Text("Additional Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...List.from(data['additionalInfo']).map((info) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(info,
                              style: const TextStyle(color: Colors.grey))),
                    ],
                  ),
                )),
            const Divider(height: 32),
            const Text("Cancellation Policy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(data['cancelPolicy'],
                style: const TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            const Text("Contact",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _detailRow(Icons.phone, "Phone", data['contact']),
            const SizedBox(height: 8),
            _detailRow(Icons.mail, "Email", "support@hoofhub.com"),
          ],
        ),
      ),
    );
  }

  Widget _iconText(IconData icon, String title, String subtitle) {
    return Container(
      width: 80,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF723594).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: const Color(0xFF723594), size: 20),
          ),
          const SizedBox(height: 8),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF723594)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
            const SizedBox(height: 4),
          ],
        ),
      ],
    );
  }
}

class Ride {
  final String title;
  final String description;
  final String location;
  final String duration;
  final double price;
  final double rating;
  final int reviews;
  final String image;
  final List<String> includes;
  final int maxParticipants;
  final Map<String, String> specifications;
  final String expect;
  final Map<String, String> route;
  final List<String> additionalInfo;
  final String cancelPolicy;
  final String contact;
  final String distance;

  Ride({
    required this.title,
    required this.description,
    required this.location,
    required this.duration,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.includes,
    required this.maxParticipants,
    required this.specifications,
    required this.expect,
    required this.route,
    required this.additionalInfo,
    required this.cancelPolicy,
    required this.contact,
    required this.distance,
  });
}
