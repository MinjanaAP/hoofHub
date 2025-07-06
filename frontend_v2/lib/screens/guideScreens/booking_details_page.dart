import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/services/booking_service.dart';
import 'package:intl/intl.dart';

class BookingDetailsPage extends StatefulWidget {
  final Map<String, dynamic> booking;
  final Color primaryColor;

  const BookingDetailsPage({
    Key? key,
    required this.booking,
    required this.primaryColor,
  }) : super(key: key);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  String? _selectedStatus;
  String? _rejectionReason;
  String? _customReason;
  final TextEditingController _customReasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.booking['status'];
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.booking['ride'];
    final rider = widget.booking['rider'];
    final date = DateTime.parse(widget.booking['selectedDate']);
    final formattedDate = DateFormat('EEE, MMM d, y').format(date);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: const CustomAppBar(
        title: 'hoofHub',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Overview Card
            _buildBookingCard(ride, rider, formattedDate),

            const SizedBox(height: 24),

            // Ride Details Section
            _buildSectionHeader('Ride Information'),
            _buildRideDetails(ride),

            const SizedBox(height: 24),

            // Rider Details Section
            _buildSectionHeader('Rider Information'),
            _buildRiderDetails(rider),

            const SizedBox(height: 24),

            // Status Management Section
            _buildSectionHeader('Booking Status'),
            _buildStatusManagement(),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildBookingCard(
      Map<String, dynamic> ride, Map<String, dynamic> rider, String date) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ride['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.booking['status']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.booking['status'].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(date, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(widget.booking['selectedTime'],
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(rider['name'], style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: widget.primaryColor,
        ),
      ),
    );
  }

  Widget _buildRideDetails(Map<String, dynamic> ride) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Location', ride['location']),
            _buildDetailRow('Duration', ride['duration']),
            _buildDetailRow('Distance', ride['distance']),
            _buildDetailRow('Price', 'LKR ${ride['price']}'),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text('Includes:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: (ride['includes'] as List)
                  .map((item) => Chip(
                        label: Text(item),
                        backgroundColor: Colors.grey[200],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiderDetails(Map<String, dynamic> rider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: widget.primaryColor.withOpacity(0.2),
                child: Icon(Icons.person, color: widget.primaryColor),
              ),
              title: Text(rider['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(rider['email']),
            ),
            _buildDetailRow('Phone', rider['mobileNumber']),
            _buildDetailRow('Member Since',
                DateFormat('MMM y').format(DateTime.parse(rider['createdAt']))),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusManagement() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Change Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: ['pending', 'confirmed', 'rejected'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status[0].toUpperCase() + status.substring(1),
                      style: TextStyle(
                        color: _getStatusColor(status),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                    if (value != 'rejected') {
                      _rejectionReason = null;
                      _customReason = null;
                    }
                  });
                },
              ),
              if (_selectedStatus == 'rejected') ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _rejectionReason,
                  decoration: InputDecoration(
                    labelText: 'Reason for Rejection',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    'No availability',
                    'Rider not qualified',
                    'Weather conditions',
                    'Other'
                  ].map((reason) {
                    return DropdownMenuItem(
                      value: reason,
                      child: Text(reason),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _rejectionReason = value;
                      if (value != 'Other') {
                        _customReason = null;
                        _customReasonController.clear();
                      }
                    });
                  },
                  validator: (value) {
                    if (_selectedStatus == 'rejected' && value == null) {
                      return 'Please select a reason';
                    }
                    return null;
                  },
                ),
                if (_rejectionReason == 'Other') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _customReasonController,
                    decoration: InputDecoration(
                      labelText: 'Custom Reason',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 2,
                    onChanged: (value) {
                      _customReason = value;
                    },
                    validator: (value) {
                      if (_rejectionReason == 'Other' &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter a reason';
                      }
                      return null;
                    },
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: widget.primaryColor),
              ),
              child: Text(
                'BACK',
                style: TextStyle(color: widget.primaryColor),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleStatusUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'UPDATE STATUS',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  void _handleStatusUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    // Prepare rejection data if needed
    final rejectionData = _selectedStatus == 'rejected'
        ? {
            'reason':
                _rejectionReason == 'Other' ? _customReason : _rejectionReason,
            
          }
        : null;

    final String? rejectionReason = _selectedStatus == 'rejected'
    ? (_rejectionReason == 'Other' ? _customReason : _rejectionReason)
    : null;
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Call your API here
      // await BookingService.updateStatus(
      //   bookingId: widget.booking['id'],
      //   status: _selectedStatus!,
      //   rejectionData: rejectionData,
      // );

      await BookingService.updateBookingStatus(
        bookingId: widget.booking['id'],
        status: _selectedStatus!,
        rejectionReason: rejectionReason,
      );

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Close loading indicator
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to $_selectedStatus'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back with updated data
      Navigator.pop(context, {
        ...widget.booking,
        'status': _selectedStatus,
        if (rejectionData != null) ...rejectionData,
      });
    } catch (e) {
      Navigator.pop(context); // Close loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
