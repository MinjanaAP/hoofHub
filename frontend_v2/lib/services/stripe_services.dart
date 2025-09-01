import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/screens/BookingScreens/payment_result_page.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'package:http/http.dart' as http;

class StripeServices {
  StripeServices._();
  static final StripeServices instance = StripeServices._();

  Future<void> makePayment({
    required int amount,
    required String bookingId,
    required String userId,
    required String riderId,
    required String date,
    required String time,
    required String guideId,
    required BuildContext context,
  }) async {
    try {
      final clientSecret = await createPaymentIntent(amount);
      logger.d("Client Secret: $clientSecret");

      if (clientSecret == null) {
        throw Exception("Failed to create Payment Intent");
      }

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "HoofHub",
      ));

      await _processPayment(clientSecret);

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
        'paymentStatus': 'paid',
        'paidBy': userId,
        'paidAt': DateTime.now(),
      });

      //! generate and save qr
      await saveQr(bookingId);

      // ! Send notifications to rider and guide
      await sendPaymentNotification(
        riderId: userId,
        guideId: guideId,
        riderTitle: "Payment Successful",
        riderDescription:
            "Your payment of \$${(amount).toStringAsFixed(2)} for the ride on $date at $time has been successfully processed.",
        guideTitle: "New Booking Payment Received",
        guideDescription:
            "You have received a payment of \$${(amount).toStringAsFixed(2)} for a booking scheduled on $date at $time.",
      ).catchError((e) {
        logger.e("Notification error, but continuing to result page: $e");
      });

      _showPaymentResult(
        context: context,
        isSuccess: true,
        bookingId: bookingId,
        amount: amount.toDouble(),
      );
    } on StripeException catch (e) {
      logger.e("Stripe error: ${e.error.localizedMessage}");
      // ! Show error page
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
          riderId: riderId,
          date: date,
          time: time,
          guideId: guideId,
          context: context,
        ),
      );
    } catch (e) {
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
          riderId: riderId,
          userId: userId,
          date: date,
          guideId: guideId,
          time: time,
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
      logger.i(" Payment Successful");
    } on StripeException catch (e) {
      logger.e("Stripe error: ${e.error.localizedMessage}");
      rethrow;
    } catch (e) {
      logger.e("Payment error: $e");
      rethrow;
    }
  }

  //? Send notifications for rider and guide
  Future<void> sendPaymentNotification({
    required String riderId,
    required String guideId,
    required String riderTitle,
    required String riderDescription,
    required String guideTitle,
    required String guideDescription,
  }) async {
    try {
      var requestData = {
        "riderId": riderId,
        "guideId": guideId,
        "riderTitle": riderTitle,
        "riderDescription": riderDescription,
        "guideTitle": guideTitle,
        "guideDescription": guideDescription,
      };

      logger.d("Sending notification with data: $requestData");

      final response = await http.post(
        Uri.parse(
            '${ApiConstants.baseUrl}/notifications/notify-payment-success'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "riderId": riderId,
          "guideId": guideId,
          "riderTitle": riderTitle,
          "riderDescription": riderDescription,
          "guideTitle": guideTitle,
          "guideDescription": guideDescription,
        }),
      );

      print("Notification API response: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (decoded['status'] == true || decoded['success'] == true) {
        logger.i("✅ Notifications sent successfully: ${decoded['message']}");
      } else {
        logger.e("⚠️ Failed to send notification: ${decoded.toString()}");
      }
    } catch (e) {
      logger.e("❌ Error sending notification: $e");
    }
  }

  Future<String?> saveQr(String bookingId) async {
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}/bookings/save-qr/$bookingId");
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == true) {
          logger.i("qr generated successfully");
          return data["qrCodeUrl"];
        } else {
          logger.e("QR generated failed");
          throw Exception("Failed: status is false");
        }
      } else {
        logger.e("QR generated failed : ${response.statusCode}");
        throw Exception("Failed with code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("error saving QR : $e");
      print("Error saving QR: $e");
      return null;
    }
  }
}
