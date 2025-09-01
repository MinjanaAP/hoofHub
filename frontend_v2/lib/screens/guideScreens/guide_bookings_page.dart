import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/guide_components/guide_bottom_nav_bar.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/screens/guideScreens/booking_details_page.dart';
import 'package:frontend/theme.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GuideBookingsPage extends StatefulWidget {
  const GuideBookingsPage({Key? key}) : super(key: key);

  @override
  State<GuideBookingsPage> createState() => _GuideBookingsPageState();
}

class _GuideBookingsPageState extends State<GuideBookingsPage> {
  late StreamController<List<dynamic>> _bookingController;
  List<dynamic> _allBookings = [];
  String _selectedFilter = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _bookingController = StreamController<List<dynamic>>.broadcast();
    // _startListening();
    _fetchBookings();
  }

  void _startListening() async {
    Timer.periodic(const Duration(seconds: 10), (_) => _fetchBookings());
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String guideId = user?.uid ?? '';
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}/bookings/guide/$guideId");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _allBookings = data;
        });
        _bookingController.add(data);
      } else {
        _bookingController.addError("Failed to load bookings");
      }
    } catch (e) {
      _bookingController.addError("Error: $e");
    }
  }

  List<dynamic> get _filteredBookings {
    List<dynamic> filtered = _allBookings;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((booking) {
        final riderName =
            booking['rider']?['name']?.toString().toLowerCase() ?? '';
        final rideTitle =
            booking['ride']?['title']?.toString().toLowerCase() ?? '';
        final location =
            booking['ride']?['location']?.toString().toLowerCase() ?? '';

        return riderName.contains(_searchQuery.toLowerCase()) ||
            rideTitle.contains(_searchQuery.toLowerCase()) ||
            location.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered
          .where((booking) => booking['status'] == _selectedFilter)
          .toList();
    }

    // Sort by date (newest first)
    filtered.sort((a, b) {
      final dateA = DateTime.parse(a['selectedDate']);
      final dateB = DateTime.parse(b['selectedDate']);
      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  List<dynamic> get _pendingBookings =>
      _allBookings.where((b) => b['status'] == 'pending').toList();
  List<dynamic> get _confirmedBookings =>
      _allBookings.where((b) => b['status'] == 'confirmed').toList();
  List<dynamic> get _completedBookings =>
      _allBookings.where((b) => b['status'] == 'completed').toList();
  List<dynamic> get _rejectedBookings =>
      _allBookings.where((b) => b['status'] == 'rejected').toList();

  @override
  void dispose() {
    _bookingController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Bookings", showBackButton: true),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchFilterBar(),

          // Status Quick Filters
          _buildStatusFilters(),

          // Bookings List
          Expanded(
            child: _allBookings.isEmpty
                ? _buildEmptyState()
                : _filteredBookings.isEmpty
                    ? _buildNoResults()
                    : _buildBookingsList(),
          ),
        ],
      ),
      bottomNavigationBar:const GuideBottomNavBar(selectedIndex: 2),
    );
  }

  Widget _buildSearchFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by rider, ride, or location...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _selectedFilter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Bookings')),
              const PopupMenuItem(value: 'pending', child: Text('Pending')),
              const PopupMenuItem(value: 'confirmed', child: Text('Confirmed')),
              const PopupMenuItem(value: 'completed', child: Text('Completed')),
              const PopupMenuItem(value: 'rejected', child: Text('Rejected')),
            ],
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildStatusChip('All', _allBookings.length, 'all'),
          const SizedBox(width: 8),
          _buildStatusChip('Pending', _pendingBookings.length, 'pending'),
          const SizedBox(width: 8),
          _buildStatusChip('Confirmed', _confirmedBookings.length, 'confirmed'),
          const SizedBox(width: 8),
          _buildStatusChip('Completed', _completedBookings.length, 'completed'),
          const SizedBox(width: 8),
          _buildStatusChip('Rejected', _rejectedBookings.length, 'rejected'),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, int count, String status) {
    final isSelected = _selectedFilter == status;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilter = status),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
      ),
    );
  }

  Widget _buildBookingsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = _filteredBookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final ride = booking['ride'] ?? {};
    final rider = booking['rider'] ?? {};
    final date = DateTime.parse(booking['selectedDate']);
    final formattedDate = DateFormat('MMM dd, yyyy').format(date);
    final status = booking['status'] ?? 'pending';
    final paymentStatus = booking['paymentStatus'] ?? 'unpaid';
    final isPaid = paymentStatus == 'paid';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status and date
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(status),
                  ),
                ),
                const Spacer(),
                if (isPaid)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 12, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          'Paid',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Booking content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ride info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ride image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        ride['images']?[0] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child:
                              const Icon(Icons.image_not_supported, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ride['title'] ?? 'No title',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ride['location'] ?? 'No location',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'LKR ${ride['price'] ?? '0'}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),

                // Rider info
                const SizedBox(height: 8),
                Text(
                  'Rider Information',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rider['name'] ?? 'No name provided',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rider['mobileNumber'] ?? 'No phone number',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),

                // Time and duration
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoItem(
                        Icons.access_time, booking['selectedTime'] ?? 'N/A'),
                    const SizedBox(width: 16),
                    _buildInfoItem(Icons.timer, ride['duration'] ?? 'N/A'),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(12),
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
                            primaryColor: AppColors.primary,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                    ),
                    child: const Text('VIEW DETAILS'),
                  ),
                ),
                const SizedBox(width: 12),
                if (status == 'pending')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle booking action (accept/reject)
                        _showBookingActions(booking);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('ACTIONS',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Bookings Yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Your bookings will appear here',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showBookingActions(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Booking Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Accept Booking'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle accept booking
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Reject Booking'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle reject booking
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
