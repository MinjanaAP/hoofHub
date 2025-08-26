import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/screens/riderScreens/rider_booking_details_page.dart';
import 'package:frontend/theme.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:lottie/lottie.dart';

class PaymentResultPage extends StatelessWidget {
  final bool isSuccess;
  final String? errorMessage;
  final String bookingId;
  final double amount;
  final VoidCallback? onRetry;
  final VoidCallback? onViewBooking;

  const PaymentResultPage({
    super.key,
    required this.isSuccess,
    this.errorMessage,
    required this.bookingId,
    required this.amount,
    this.onRetry,
    this.onViewBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        title: "Payment Status",
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Illustration
                Lottie.asset(
                  isSuccess
                      ? 'assets/animations/payment-success.json'
                      : 'assets/animations/payment-error.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  isSuccess ? 'Payment Successful!' : 'Payment Failed',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSuccess
                            ? const Color.fromRGBO(114, 53, 147, 1)
                            : Colors.red,
                      ),
                ),

                const SizedBox(height: 16),

                Text(
                  isSuccess
                      ? 'Your payment has been processed successfully. Your booking is now confirmed!'
                      : errorMessage ??
                          'There was an issue processing your payment. Please try again.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),

                const SizedBox(height: 24),

                // Payment Details Card
                _buildPaymentDetailsCard(context),

                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentDetailsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow('Booking ID', bookingId),
          const Divider(),
          _buildDetailRow('Amount', 'LKR ${amount.toStringAsFixed(2)}'),
          const Divider(),
          _buildDetailRow(
            'Status',
            isSuccess ? 'Paid' : 'Failed',
            valueColor: isSuccess ? Colors.green : Colors.red,
          ),
          const Divider(),
          _buildDetailRow(
            'Date',
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (isSuccess)
          ElevatedButton(
            onPressed: onViewBooking ??
                () {
                  // Navigate to booking details or home
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RiderBookingDetailsPage (
                        bookingId: bookingId,
                      ),
                    ),
                  );
                },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('View Booking'),
          ),
        if (!isSuccess)
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Try Again'),
          ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
          child: const Text(
            'Back to Home',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
