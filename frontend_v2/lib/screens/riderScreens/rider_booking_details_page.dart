import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/screens/skeletons/custom_loading_page.dart';
import 'package:frontend/theme.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiderBookingDetailsPage extends StatefulWidget {
  final String bookingId;

  const RiderBookingDetailsPage({super.key, required this.bookingId});

  @override
  State<RiderBookingDetailsPage> createState() => _RiderBookingDetailsPageState();
}

class _RiderBookingDetailsPageState extends State<RiderBookingDetailsPage> {
  late Future<Map<String, dynamic>> _bookingDetails;
  bool _isLoading = true;
  Map<String, dynamic>? _bookingData;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _bookingDetails = _fetchBookingDetails();
  }

  Future<Map<String, dynamic>> _fetchBookingDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/bookings/${widget.bookingId}/details'),
      );
      // logger.e('Booking details response: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _bookingData = data;
          _isLoading = false;
        });
        return data;
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load booking details. Status code: ${response.statusCode}';
        });
        throw Exception('Failed to load booking details');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching booking details: ${e.toString()}';
      });
      throw Exception('Failed to load booking details: $e');
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('EEEE, MMMM d, yyyy').format(date);
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
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Booking Details",
        showBackButton: true,
      ),
      body: _isLoading
          ? const CustomLoadingScreen()
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _bookingData == null
                  ? const Center(child: Text('No booking data available'))
                  : _buildBookingDetailsContent(),
    );
  }

  Widget _buildBookingDetailsContent() {
    final ride = _bookingData!['ride'] as Map<String, dynamic>;
    final guide = _bookingData!['guide'] as Map<String, dynamic>;
    final rider = _bookingData!['rider'] as Map<String, dynamic>;
    final status = (_bookingData!['status'] as String).toUpperCase();
    final date = formatDate(_bookingData!['selectedDate']);
    final time = formatTime(_bookingData!['selectedTime'] as String);
    final rideType = _bookingData!['rideType'] as String? ?? 'single';
    final rejectionReason = _bookingData!['rejectionReason'] as String?;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking status card
          _buildStatusCard(context, status, date, time, rejectionReason),
          const SizedBox(height: 24),
          
          // Ride details section
          _buildSectionHeader('Ride Information'),
          const SizedBox(height: 12),
          _buildRideDetailsCard(ride),
          const SizedBox(height: 24),
          
          // Booking details section
          _buildSectionHeader('Booking Details'),
          const SizedBox(height: 12),
          _buildBookingDetailsCard(),
          const SizedBox(height: 24),
          
          // Guide details section
          _buildSectionHeader('Your Guide'),
          const SizedBox(height: 12),
          _buildGuideCard(guide),
          const SizedBox(height: 24),
          
          // Rider details section
          _buildSectionHeader('Your Information'),
          const SizedBox(height: 12),
          _buildRiderCard(rider),
          const SizedBox(height: 24),
          
          // Cancellation policy
          if (ride['cancelPolicy'] != null) ...[
            _buildSectionHeader('Cancellation Policy'),
            const SizedBox(height: 12),
            _buildPolicyCard(ride['cancelPolicy'] as String),
            const SizedBox(height: 24),
          ],
          
          // Action buttons
          if (_bookingData!['status'].toString().toLowerCase() == 'pending' ||
              _bookingData!['status'].toString().toLowerCase() == 'confirmed')
            _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, String status, String date, String time, String? rejectionReason) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: getStatusColor(status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: getStatusColor(status),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: getStatusColor(status),
                ),
              ),
              
            ],
          ),
          const SizedBox(height: 8),
              Text(
                '$date • $time',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
          const SizedBox(height: 8),
          if (rejectionReason != null && rejectionReason.isNotEmpty && status.toLowerCase() == 'rejected')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                rejectionReason,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red.shade700,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Color.fromARGB(255, 55, 3, 83)
          ), 
    );
  }

  Widget _buildRideDetailsCard(Map<String, dynamic> ride) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ride image and title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride['title'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'LKR ${ride['price']}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Ride details in grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildDetailItem(Icons.location_on, 'Location', ride['location']),
                _buildDetailItem(Icons.timer, 'Duration', ride['duration']),
                _buildDetailItem(Icons.landscape, 'Distance', ride['distance']),
                _buildDetailItem(Icons.people, 'Max Riders', ride['maxParticipants'].toString()),
              ],
            ),
            const SizedBox(height: 16),
            
            // Description
            Text(
              ride['description'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            
            // What's included
            if (ride['includes'] != null && (ride['includes'] as List).isNotEmpty) ...[
              Text(
                'What\'s Included:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (ride['includes'] as List)
                    .map((item) => Chip(
                          label: Text(item.toString()),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          labelStyle: TextStyle(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

 Widget _buildDetailItem(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, size: 20, color: AppColors.primary),
      const SizedBox(width: 8),
      Expanded( // Add Expanded to constrain the text width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, 
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1, 
              overflow: TextOverflow.ellipsis, 
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildBookingDetailsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookingDetailRow('Booking ID', _bookingData!['id']),
            const Divider(),
            _buildBookingDetailRow('Booking Date', 
                DateFormat('MMM dd, yyyy - hh:mm a').format(DateTime.parse(_bookingData!['createdAt']))),
            const Divider(),
            _buildBookingDetailRow('Ride Type', 
                '${_bookingData!['rideType'][0].toUpperCase()}${_bookingData!['rideType'].toString().substring(1)}'),
            const Divider(),
            _buildBookingDetailRow('Status', 
                '${_bookingData!['status'][0].toUpperCase()}${_bookingData!['status'].toString().substring(1)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(Map<String, dynamic> guide) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: guide['profileImage'] != null && guide['profileImage'].toString().isNotEmpty
                      ? NetworkImage(guide['profileImage'] as String)
                      : null,
                  child: guide['profileImage'] == null || guide['profileImage'].toString().isEmpty
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guide['fullName'] as String? ?? 'Unknown Guide',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        guide['experience'] as String? ?? 'Experienced Guide',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildDetailItem(Icons.phone, 'Contact', guide['mobileNumber']),
                _buildDetailItem(Icons.email, 'Email', guide['email']),
                _buildDetailItem(Icons.translate, 'Languages', guide['languages']),
                _buildDetailItem(Icons.work, 'Experience', guide['experience']),
              ],
            ),
            const SizedBox(height: 16),
            if (guide['bio'] != null && guide['bio'].toString().isNotEmpty)
              Text(
                guide['bio'] as String,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiderCard(Map<String, dynamic> rider) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rider['name'] as String? ?? 'Unknown Rider',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Rider',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildDetailItem(Icons.phone, 'Contact', rider['mobileNumber']),
                _buildDetailItem(Icons.email, 'Email', rider['email']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyCard(String policy) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                policy,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (_bookingData!['status'].toString().toLowerCase() == 'pending')
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // TODO: Handle cancel booking
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text(
                'CANCEL BOOKING',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        if (_bookingData!['status'].toString().toLowerCase() == 'pending')
          const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Handle contact guide
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('CONTACT GUIDE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}