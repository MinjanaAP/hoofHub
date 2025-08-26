import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/screens/BookingScreens/payment_result_page.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class StripeServices {
  StripeServices._();
  static final StripeServices instance = StripeServices._();

  Future<void> makePayment({
    required int amount,
    required String bookingId,
    required String userId,
    required BuildContext context, // Add context for navigation
  }) async {
    try {
      // 1. Create PaymentIntent on backend
      final clientSecret = await createPaymentIntent(amount);
      logger.d("Client Secret: $clientSecret");

      if (clientSecret == null) {
        throw Exception("Failed to create Payment Intent");
      }

      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "HoofHub",
      ));

      // 3. Present the payment sheet to the user
      await _processPayment(clientSecret);

      // 4. Update ride status in Firestore
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
        'paymentStatus': 'paid',
        'paidBy': userId,
        'paidAt': DateTime.now(),
      });

      // 5. Show success page
      _showPaymentResult(
        context: context,
        isSuccess: true,
        bookingId: bookingId,
        amount: amount.toDouble(),
      );
    } on StripeException catch (e) {
      print("❌ Stripe error: ${e.error.localizedMessage}");
      logger.e("Stripe error: ${e.error.localizedMessage}");

      // Show error page
      _showPaymentResult(
        context: context,
        isSuccess: false,
        errorMessage: e.error.localizedMessage,
        bookingId: bookingId,
        amount: amount.toDouble(),
        onRetry: () => makePayment(
          amount: amount,
          bookingId: bookingId,
          userId: userId,
          context: context,
        ),
      );
    } catch (e) {
      print("❌ Payment error: $e");
      logger.e("Payment error: $e");

      // Show error page
      _showPaymentResult(
        context: context,
        isSuccess: false,
        errorMessage: e.toString(),
        bookingId: bookingId,
        amount: amount.toDouble(),
        onRetry: () => makePayment(
          amount: amount,
          bookingId: bookingId,
          userId: userId,
          context: context,
        ),
      );
    }
  }

  void _showPaymentResult({
    required BuildContext context,
    required bool isSuccess,
    String? errorMessage,
    required String bookingId,
    required double amount,
    VoidCallback? onRetry,
  }) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentResultPage(
          isSuccess: isSuccess,
          errorMessage: errorMessage,
          bookingId: bookingId,
          amount: amount,
          onRetry: onRetry,
          onViewBooking: () {
            // Navigate to booking details page
            // Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailsPage(bookingId: bookingId)));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      (route) => false,
    );
  }

  Future<String?> createPaymentIntent(int amount) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/payment/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"amount": amount}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true && decoded['data'] != null) {
          final clientSecret = decoded['data']['clientSecret'];
          return clientSecret;
        } else {
          throw Exception(
              "Failed to create Payment Intent: ${decoded['message']}");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error creating Payment Intent: $e");
      return null;
    }
  }

  Future<void> _processPayment(String clientSecret) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("✅ Payment Successful");
    } on StripeException catch (e) {
      print("❌ Stripe error: ${e.error.localizedMessage}");
      logger.e("Stripe error: ${e.error.localizedMessage}");
      rethrow;
    } catch (e) {
      print("❌ Payment error: $e");
      logger.e("Payment error: $e");
      rethrow;
    }
  }
}
