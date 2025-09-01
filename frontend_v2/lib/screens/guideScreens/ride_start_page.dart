import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/theme.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/constant/api_constants.dart';

class RideStartPage extends StatefulWidget {
  final Map<String, dynamic> apiResponse;

  const RideStartPage({super.key, required this.apiResponse});

  @override
  State<RideStartPage> createState() => _RideStartPageState();
}

class _RideStartPageState extends State<RideStartPage> {
  late Map<String, dynamic> _booking;
  late Map<String, dynamic> _ride;
  late Map<String, dynamic> _rider;
  late Map<String, dynamic> _guide;
  bool _isLoading = true;
  bool _rideStarted = false;
  Duration _rideDuration = Duration.zero;
  Timer? _rideTimer;

  @override
  void initState() {
    super.initState();
    _processApiResponse();
  }

  void _processApiResponse() {
    final response = widget.apiResponse;
    _booking = response['booking'] ?? {};
    _ride = response['ride'] ?? {};
    _rider = response['rider'] ?? {};
    _guide = response['guide'] ?? {};
    
    final rideStatus = _booking['rideStatus'] ?? 'confirmed';
    if (rideStatus == 'started') {
      _rideStarted = true;
      _startRideTimer();
    }
    
    _isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _rideTimer?.cancel();
    super.dispose();
  }

  void _startRideTimer() {
    _rideTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _rideDuration = _rideDuration + const Duration(seconds: 1);
      });
    });
  }

  Future<void> _startRide() async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/bookings/change-ride-status/${_booking['id']}"),
        headers: {'Content-Type': 'application/json'},
        body: '{"status": "started"}',
      );

      if (response.statusCode == 200) {
        setState(() {
          _rideStarted = true;
          _booking['rideStatus'] = 'started';
        });
        _startRideTimer();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride started successfully!')),
        );
      } else {
        throw Exception('Failed to start ride: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start ride: ${e.toString()}')),
      );
    }
  }

  Future<void> _completeRide() async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/bookings/change-ride-status/${_booking['id']}"),
        headers: {'Content-Type': 'application/json'},
        body: '{"status": "completed"}',
      );

      if (response.statusCode == 200) {
        _rideTimer?.cancel();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride completed successfully!')),
        );
        
        Navigator.pop(context);
      } else {
        throw Exception('Failed to complete ride: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete ride: ${e.toString()}')),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  String _formatDate(String dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatFirebaseTimestamp(dynamic timestamp) {
    if (timestamp is Map<String, dynamic>) {
      try {
        final seconds = timestamp['_seconds'] as int;
        final nanoseconds = timestamp['_nanoseconds'] as int;
        final date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000 + nanoseconds ~/ 1000000);
        return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
      } catch (e) {
        return 'Invalid date';
      }
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: const CustomAppBar(title: "Starting Ride", showBackButton: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: "Ride Management", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _buildStatusCard(),
            const SizedBox(height: 24),

            if (_rideStarted) _buildTimerCard(),
            if (_rideStarted) const SizedBox(height: 24),

            // Booking Information
            _buildSectionHeader('Booking Information'),
            const SizedBox(height: 12),
            _buildBookingInfoCard(),
            const SizedBox(height: 24),

            // Ride Information
            _buildSectionHeader('Ride Details'),
            const SizedBox(height: 12),
            _buildRideInfoCard(),
            const SizedBox(height: 24),

            // Rider Information
            _buildSectionHeader('Rider Information'),
            const SizedBox(height: 12),
            _buildRiderCard(),
            const SizedBox(height: 24),

            // Guide Information
            _buildSectionHeader('Your Information'),
            const SizedBox(height: 12),
            _buildGuideCard(),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final rideStatus = _booking['rideStatus'] ?? 'confirmed';
    final statusColor = rideStatus == 'started' ? Colors.green : 
                       rideStatus == 'completed' ? Colors.blue : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            rideStatus == 'started' ? Icons.directions_bike : 
            rideStatus == 'completed' ? Icons.check_circle : Icons.timer,
            color: statusColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rideStatus == 'started' ? 'Ride in Progress' : 
                  rideStatus == 'completed' ? 'Ride Completed' : 'Ready to Start',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rideStatus == 'started' ? 'Ride is currently ongoing' : 
                  rideStatus == 'completed' ? 'Ride has been completed' : 'Confirm rider presence to start',
                  style: TextStyle(color: statusColor.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Ride Duration',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  _formatDuration(_rideDuration),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'HH:MM:SS',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildBookingInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Booking ID', _booking['id'] ?? 'N/A'),
            const Divider(),
            _buildInfoRow('Ride Type', _booking['rideType']?.toString().toUpperCase() ?? 'N/A'),
            const Divider(),
            _buildInfoRow('Date', _formatDate(_booking['selectedDate'] ?? '')),
            const Divider(),
            _buildInfoRow('Time', _booking['selectedTime'] ?? 'N/A'),
            const Divider(),
            _buildInfoRow('Payment Status', _booking['paymentStatus']?.toString().toUpperCase() ?? 'N/A'),
            const Divider(),
            _buildInfoRow('Paid At', _formatFirebaseTimestamp(_booking['paidAt'])),
          ],
        ),
      ),
    );
  }

  Widget _buildRideInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Ride Name', _ride['title'] ?? 'N/A'),
            const Divider(),
            _buildInfoRow('Location', _ride['location'] ?? 'N/A'),
            const Divider(),
            _buildInfoRow('Duration', _ride['duration'] ?? 'N/A'),
            const Divider(),
            _buildInfoRow('Distance', _ride['distance'] ?? 'N/A'),
            const Divider(),
            _buildInfoRow('Price', 'LKR ${_ride['price']?.toString() ?? 'N/A'}'),
            const Divider(),
            _buildInfoRow('Difficulty', _ride['specifications']?['difficulty'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, size: 30, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _rider['name'] ?? 'Unknown Rider',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _rider['email'] ?? 'No email',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _rider['mobileNumber'] ?? 'No phone number',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(_guide['profileImage'] ?? ''),
              onBackgroundImageError: (_, __) => const Icon(Icons.person),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _guide['fullName'] ?? 'Unknown Guide',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _guide['experience'] ?? 'No experience info',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _guide['mobileNumber'] ?? 'No phone number',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final rideStatus = _booking['rideStatus'] ?? 'confirmed';

    return Column(
      children: [
        if (rideStatus == 'scanned' )
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startRide,
              style: ElevatedButton.styleFrom(
                
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, size: 24),
                  SizedBox(width: 8),
                  Text('START RIDE', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),

        if (rideStatus == 'started') ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _completeRide,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.playlist_add_check_circle_outlined, size: 24, color: Colors.white,),
                  SizedBox(width: 8),
                  Text('COMPLETE RIDE', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Add emergency or pause functionality
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                side: const BorderSide(color: Colors.red),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Text('EMERGENCY STOP', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ],

        if (rideStatus == 'completed')
          const Text(
            'Ride has been completed successfully',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}