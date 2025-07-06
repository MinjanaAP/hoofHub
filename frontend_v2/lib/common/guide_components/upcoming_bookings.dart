import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/screens/guideScreens/booking_details_page.dart';
import 'package:http/http.dart' as http;

class UpcomingBookingsWidget extends StatefulWidget {
  final String guideId;
  final Color primaryColor;

  const UpcomingBookingsWidget({
    Key? key,
    required this.guideId,
    required this.primaryColor,
  }) : super(key: key);

  @override
  State<UpcomingBookingsWidget> createState() => _UpcomingBookingsWidgetState();
}

class _UpcomingBookingsWidgetState extends State<UpcomingBookingsWidget> {
  late StreamController<List<dynamic>> _bookingController;

  @override
  void initState() {
    super.initState();
    _bookingController = StreamController<List<dynamic>>.broadcast();
    _startListening();
  }

  void _startListening() async {
    // In real-time Firebase, you'd use snapshot listeners. Here we simulate polling every 10 seconds.
    Timer.periodic(Duration(seconds: 10), (_) => _fetchBookings());
    _fetchBookings(); // Initial fetch
  }

  Future<void> _fetchBookings() async {
    try {
      final url =
          Uri.parse("${ApiConstants.baseUrl}/bookings/guide/${widget.guideId}");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _bookingController.add(data);
      } else {
        _bookingController.addError("Failed to load bookings");
      }
    } catch (e) {
      _bookingController.addError("Error: $e");
    }
  }

  @override
  void dispose() {
    _bookingController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: _bookingController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final bookings = snapshot.data ?? [];

        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No upcoming bookings",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final ride = booking['ride'];
              final rider = booking['rider'];
              final date = DateTime.parse(booking['selectedDate']);
              // final formattedDate = DateFormat('EEE, MMM d').format(date);

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                constraints: BoxConstraints(
                  minHeight: 300, // Minimum height for each card
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image and basic info
                    SizedBox(
                      height: 180,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.network(
                              ride['images'][0],
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 180,
                                  color: Colors.grey[200],
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 180,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: booking['status'] == 'pending'
                                    ? Colors.orange
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                booking['status'].toString().toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Ride details
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  ride['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'LKR ${ride['price']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  ride['location'],
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Date and time
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildDetailItem(
                                    Icons.calendar_today, date.toString()),
                                const SizedBox(width: 16),
                                _buildDetailItem(
                                    Icons.access_time, booking['selectedTime']),
                                const SizedBox(width: 16),
                                _buildDetailItem(Icons.timer, ride['duration']),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Divider
                          Divider(color: Colors.grey[200], height: 1),
                          const SizedBox(height: 12),

                          // Rider info
                          Text(
                            'Rider Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: const Icon(Icons.person,
                                    color: Colors.grey),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rider['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      rider['mobileNumber'],
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingDetailsPage(
                                      booking: booking,
                                      primaryColor: const Color(0xFF723594),
                                    ),
                                  ),
                                ).then((updatedBooking) {
                                  if (updatedBooking != null) {
                                    // Update your state with the changed booking
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              child: Text(
                                'VIEW DETAILS',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Contact guide action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'CONTACT RIDER',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget _buildDetailItem(IconData icon, String text) {
  return Container(
    constraints: BoxConstraints(minWidth: 80), // Minimum width for each item
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    ),
  );
}
