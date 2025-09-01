import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/api_service.dart';

class ReviewServices {
  static Future<bool> submitReview({
    required String bookingId,
    required int horseRating,
    required int guideRating,
    required String reviewText,
  }) async {
    try {
      final body = {
        'bookingId': bookingId,
        'horseRating': horseRating,
        'guideRating': guideRating,
        'reviewText': reviewText
      };

      final response = await ApiService.dio.post('/reviews', data: body);
      if (response.statusCode == 201) {
        return true; 
      } else {
        logger.e("Error submitting review: ${response.data}");
        return false;
      }
    } catch (e) {
      logger.e("Error submitting review: $e");
      return false;
    }
  }
}
