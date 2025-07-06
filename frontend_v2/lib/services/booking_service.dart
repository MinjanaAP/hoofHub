import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/api_service.dart';

class BookingService {
  static Future<Map<String, dynamic>> updateBookingStatus({
    required String bookingId,
    required String status,
    String? rejectionReason,
  }) async {
    try {
      final body = {
        'status': status,
        if (status == 'rejected' && rejectionReason != null)
          'rejectionReason': rejectionReason,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final response = await ApiService.dio.put(
        '/bookings/$bookingId',
        data: body,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'message': response.data['message'] ?? 'Status updated successfully',
        };
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to update booking status');
      }
    } catch (e) {
      logger.e('Failed to update booking status: ${e.toString()}');
      throw Exception('Failed to update booking status: ${e.toString()}');
    }
  }
}
