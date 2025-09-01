import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class QRCodeDisplay extends StatelessWidget {
  final String qrData; // This is the image URL
  final String bookingId;
  final String rideName;
  final String date;
  final String time;

  const QRCodeDisplay({
    super.key,
    required this.qrData,
    required this.bookingId,
    required this.rideName,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            const Text(
              'Your Ride QR Code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Show this to your guide at the ride location',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // QR Code Image Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CachedNetworkImage(
                imageUrl: qrData,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(40),
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load QR code',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Booking Details
            _buildDetailRow('Booking ID', bookingId),
            const SizedBox(height: 8),
            _buildDetailRow('Ride', rideName),
            const SizedBox(height: 8),
            _buildDetailRow('Date', date),
            const SizedBox(height: 8),
            _buildDetailRow('Time', time),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    child: const Text(
                      'CLOSE',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}