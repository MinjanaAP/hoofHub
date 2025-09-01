import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_nav_bar.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/guide_components/guide_bottom_nav_bar.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/review_services.dart';
import 'package:frontend/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OngoingRidePage extends StatefulWidget {
  const OngoingRidePage({super.key});

  @override
  State<OngoingRidePage> createState() => _OngoingRidePageState();
}

class _OngoingRidePageState extends State<OngoingRidePage> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? _bookingDetails;
  bool _isLoading = true;
  bool _hasError = false;
  StreamSubscription<DocumentSnapshot>? _bookingSubscription;
  String bookingPId = '';

  int _horseRating = 0;
  int _guideRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmittingReview = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBookingData();
    });
  }

  @override
  void dispose() {
    _bookingSubscription?.cancel();
    _reviewController.dispose();
    super.dispose();
  }

  void _initializeBookingData() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final bookingId = args?['bookingId'];
    bookingPId = bookingId;

    if (bookingId != null && _currentUser != null) {
      _setupBookingSnapshot(bookingId);
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _setupBookingSnapshot(String bookingId) {
    _bookingSubscription = FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        // Always refresh full details from backend API
        await _fetchBookingDetails(bookingId);
      } else {
        setState(() {
          _bookingDetails = null;
          _isLoading = false;
        });
      }
    }, onError: (error) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    });
  }

  Future<void> _fetchBookingDetails(String bookingId) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/bookings/$bookingId/details'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _bookingDetails = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  String _formatFirebaseTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      if (timestamp is Map<String, dynamic> &&
          timestamp.containsKey('_seconds')) {
        final seconds = timestamp['_seconds'] as int;
        final nanoseconds = timestamp['_nanoseconds'] as int? ?? 0;
        final date = DateTime.fromMillisecondsSinceEpoch(
            seconds * 1000 + (nanoseconds / 1000000).round());
        return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
      } else if (timestamp is String) {
        final date = DateTime.parse(timestamp);
        return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
      } else if (timestamp is DateTime) {
        return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp);
      }
      return 'Invalid date';
    } catch (_) {
      return 'Invalid date';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'started':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'confirmed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'started':
        return Icons.directions_bike;
      case 'completed':
        return Icons.check_circle;
      case 'confirmed':
        return Icons.timer;
      default:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Ongoing Ride',
        showBackButton: true,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _hasError
              ? _buildErrorState()
              : _bookingDetails == null
                  ? _buildNoBookingState()
                  : _buildRideContent(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildLoadingState() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: 16),
            Text(
              'Loading your ride details...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );

  Widget _buildErrorState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Oops! Something went wrong',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Could not load ride details',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initializeBookingData,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );

  Widget _buildNoBookingState() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_bike, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No Active Ride',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              'You don\'t have any ongoing rides at the moment',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );

  Widget _buildRideContent() {
    final ride = _bookingDetails!['ride'] ?? {};
    final rider = _bookingDetails!['rider'] ?? {};
    final guide = _bookingDetails!['guide'] ?? {};
    final rideStatus = _bookingDetails!['rideStatus'] ?? 'confirmed';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // _buildStatusCard(rideStatus),
          const SizedBox(height: 24),
          // Status
          Column(
            children: [
              const Icon(Icons.timer, size: 50, color: Colors.deepPurple),
              const SizedBox(height: 8),
              Text(
                "Your Ride Has $rideStatus 🚀",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: rideStatus == 'started'
                      ? Colors.green[100]
                      : Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  rideStatus == 'started' ? 'In Progress' : 'Completed',
                  style: TextStyle(
                      color:
                          rideStatus == 'started' ? Colors.green : Colors.blue,
                      fontSize: 14),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          if (rideStatus == 'completed') ...[
            _hoofCoinsSection(),
            const SizedBox(
              height: 20,
            ),
            _buildRatingSection(),
          ],

          const SizedBox(
            height: 20,
          ),
          // Ride Info
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ride['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: Colors.deepPurple),
                      const SizedBox(width: 16),
                      Text(
                        ride['location'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 18, color: Colors.deepPurple),
                      const SizedBox(width: 16),
                      Text(ride['duration'] + " remaining"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Guide & Horse Info
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(guide['profileImage']),
                                radius: 24,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(guide['fullName'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const Text("Your Guide"),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildRealTimeStatus(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRealTimeStatus() {
    final rideStatus = _bookingDetails!['rideStatus'] ?? 'confirmed';
    return Column(children: [
      const Text('Live Status',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary)),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: _getStatusColor(rideStatus), shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text('Status: ${rideStatus.toUpperCase()}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getStatusColor(rideStatus))),
      ]),
      const SizedBox(height: 4),
      Text('Last updated: ${DateFormat('hh:mm:ss a').format(DateTime.now())}',
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ]);
  }

  Widget _hoofCoinsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFF7CC).withOpacity(0.8),
            const Color(0xFFFFF0A5).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFFE880).withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Celebration Icon
          const Icon(
            Icons.celebration_rounded,
            size: 32,
            color: Color(0xFFFFD700),
          ),

          const SizedBox(height: 16),

          // Animated Circle with Coin
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7CC),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Shine effect
                Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.star_rounded,
                    size: 24,
                    color: Colors.amber[100],
                  ),
                ),

                // Main coin
                Image.asset(
                  "assets/images/coin-hoof.png",
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),

                // Sparkle effect
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Colors.amber[200],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Congratulations Message
          const Text(
            "🎉 Congratulations!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7B61FF),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Reward Amount
          const Text(
            "+50 HoofCoins",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF5D3FD3),
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          // Reward Description
          const Text(
            "You've earned 50 HoofCoins for completing your ride!",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Usage Instructions
          const Text(
            "Use your HoofCoins for discounts on future rides and exclusive rewards! 🚀",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF888888),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rate Your Experience',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Horse Rating
            _buildRatingItem('Horse Rating', _horseRating, (rating) {
              setState(() => _horseRating = rating);
            }),
            const SizedBox(height: 20),

            // Guide Rating
            _buildRatingItem('Guide Rating', _guideRating, (rating) {
              setState(() => _guideRating = rating);
            }),
            const SizedBox(height: 20),

            // Review Input
            const Text(
              'Your Review',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            _isSubmittingReview
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Review',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingItem(
      String title, int rating, Function(int) onRatingChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => onRatingChanged(index + 1),
              child: Icon(
                index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                size: 32,
                color: Colors.amber,
              ),
            );
          }),
        ),
      ],
    );
  }

  void _submitReview() async {
    if (_horseRating == 0 || _guideRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please provide ratings for both horse and guide')),
      );
      return;
    }

    setState(() => _isSubmittingReview = true);

    try {
      setState(() => _isSubmittingReview = true);

      final success = await ReviewServices.submitReview(
        bookingId:bookingPId,
        horseRating: _horseRating,
        guideRating: _guideRating,
        reviewText: _reviewController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback!'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          _horseRating = 0;
          _guideRating = 0;
          _reviewController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit review. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSubmittingReview = false);
    }
  }
}
