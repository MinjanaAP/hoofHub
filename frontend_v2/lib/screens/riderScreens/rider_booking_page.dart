import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_nav_bar.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/riderScreens/rider_booking_details_page.dart';
import 'package:frontend/screens/skeletons/booking_card_skelton.dart';
import 'package:frontend/screens/skeletons/custom_loading_page.dart';
import 'package:frontend/theme.dart';
import 'package:intl/intl.dart';

class RiderBookingsPage extends StatefulWidget {
  const RiderBookingsPage({super.key});

  @override
  State<RiderBookingsPage> createState() => _RiderBookingsPageState();
}

class _RiderBookingsPageState extends State<RiderBookingsPage> {
  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return 'N/A';
    try {
      if (timeString.contains('PM') || timeString.contains('AM')) {
        return timeString;
      }
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        int hour = int.tryParse(parts[0]) ?? 0;
        final minute = parts[1].split(' ')[0];
        final period = hour >= 12 ? 'PM' : 'AM';
        hour = hour > 12 ? hour - 12 : hour;
        return '$hour:$minute $period';
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color.fromARGB(255, 147, 111, 53);
      case 'accepted':
      case 'completed':
        return const Color.fromARGB(255, 53, 87, 147);
      case 'confirmed':
        return const Color.fromARGB(255, 53, 147, 59);
      case 'rejected':
        return const Color.fromARGB(255, 147, 59, 53);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text('Not logged in'));

    return Scaffold(
      appBar: const CustomAppBar(
        title: "My Bookings",
        showBackButton: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('uid', isEqualTo: uid)
            .orderBy('selectedDate', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Center(
            //   child: CircularProgressIndicator(
            //     color: AppColors.primary,
            //   ),
            // );
            return const CustomLoadingScreen();
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const EmptyBookingsView();
          }

          // Categorize bookings
          final confirmedBookings = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['status'] as String).toLowerCase() == 'confirmed';
          }).toList();

          final pendingBookings = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['status'] as String).toLowerCase() == 'pending';
          }).toList();

          final completedBookings = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['status'] as String).toLowerCase() == 'completed' ||
                (data['status'] as String).toLowerCase() == 'accepted';
          }).toList();

          final rejectedBookings = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['status'] as String).toLowerCase() == 'rejected';
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (confirmedBookings.isNotEmpty) ...[
                  _buildSectionHeader(
                      'Confirmed Bookings', confirmedBookings.length),
                  const SizedBox(height: 8),
                  ...confirmedBookings.reversed
                      .map((doc) => _buildBookingCard(doc))
                      .toList(),
                  const SizedBox(height: 24),
                ],
                if (pendingBookings.isNotEmpty) ...[
                  _buildSectionHeader(
                      'Upcoming Bookings', pendingBookings.length),
                  const SizedBox(height: 8),
                  ...pendingBookings.reversed
                      .map((doc) => _buildBookingCard(doc))
                      .toList(),
                  const SizedBox(height: 24),
                ],
                if (completedBookings.isNotEmpty) ...[
                  _buildSectionHeader(
                      'Completed Bookings', completedBookings.length),
                  const SizedBox(height: 8),
                  ...completedBookings.reversed
                      .map((doc) => _buildBookingCard(doc))
                      .toList(),
                  const SizedBox(height: 24),
                ],
                if (rejectedBookings.isNotEmpty) ...[
                  _buildSectionHeader(
                      'Rejected Bookings', rejectedBookings.length),
                  const SizedBox(height: 8),
                  ...rejectedBookings.reversed
                      .map((doc) => _buildBookingCard(doc))
                      .toList(),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(
        selectedIndex: 2,
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 55, 3, 83)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(DocumentSnapshot doc) {
    final bookingData = doc.data() as Map<String, dynamic>;
    final bookingId = doc.id;
    final rideId = bookingData['rideId'];
    final status = (bookingData['status'] as String).toUpperCase();
    final date = formatDate(bookingData['selectedDate']);
    final selectedTime = formatTime(bookingData['selectedTime'] as String);
    final rideType = bookingData['rideType'] as String? ?? 'single';
    final rejectionReason = bookingData['rejectionReason'] as String?;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('rides').doc(rideId).get(),
      builder: (context, rideSnap) {
        if (!rideSnap.hasData) {
          return const BookingCardSkelton();
        }
        if (!rideSnap.data!.exists) {
          return const SizedBox();
        }

        final ride = rideSnap.data!.data() as Map<String, dynamic>;
        final guide = bookingData['guide'] as Map<String, dynamic>?;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: getStatusColor(bookingData['status'] as String)
                      .withOpacity(0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: getStatusColor(bookingData['status'] as String),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getStatusColor(bookingData['status'] as String),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$date • $selectedTime',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ride image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            ride['images'][0],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Ride info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ride['title'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'LKR ${ride['price']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Type: ${rideType[0].toUpperCase()}${rideType.substring(1)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Guide info
                    if (guide != null) ...[
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: guide['profileImage'] != null &&
                                    guide['profileImage'].toString().isNotEmpty
                                ? NetworkImage(guide['profileImage'] as String)
                                : null,
                            child: guide['profileImage'] == null ||
                                    guide['profileImage'].toString().isEmpty
                                ? const Icon(Icons.person, size: 20)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  guide['fullName'] as String? ??
                                      'Unknown Guide',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  'Guide',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    // Rejection reason if applicable
                    if (rejectionReason != null &&
                        rejectionReason.isNotEmpty &&
                        status == 'REJECTED') ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline,
                                color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                rejectionReason,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.red.shade700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Action buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          logger.d(bookingId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RiderBookingDetailsPage(
                                bookingId: bookingId,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('VIEW DETAILS'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if ((bookingData['status'] as String).toLowerCase() ==
                        'pending')
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Handle cancel booking
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('CANCEL'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EmptyBookingsView extends StatelessWidget {
  const EmptyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_bookings.png', // Replace with your asset
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 24),
          Text(
            'No Bookings Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'You haven\'t made any bookings yet. Explore our rides and book your first adventure!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to rides page
            },
            child: const Text('Explore Rides'),
          ),
        ],
      ),
    );
  }
}
