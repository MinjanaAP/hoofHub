import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/api_service.dart';

class RideService {
  Future<List<dynamic>> getPopularRides() async {
    try {
      final response = await ApiService.dio.get('/rides/rating/top');
      if (response.statusCode == 200 && response.data['status'] == true) {
        List<dynamic> data = response.data['data'];
        return data;
      } else {
        throw Exception("Failed to load popular rides");
      }
    } catch (e) {
      throw Exception('Failed to load popular rides: $e');
    }
  }

  Future<Map<String, dynamic>> getRideById(String id) async {
    try {
      final response = await ApiService.dio.get('/rides/$id');
      logger.i('id in api call : $id');
      logger.i('Response: ${response.data}');
      return response.data;
    } catch (e) {
      logger.e('error : $e');
      throw Exception('Failed to load horse: $e');
    }
  }

   Future<List<dynamic>> getAllRides() async {
    try {
      final response = await ApiService.dio.get('/rides');
      if (response.statusCode == 200 && response.data['status'] == true) {
        List<dynamic> data = response.data['data'];
        return data;
      } else {
        throw Exception("Failed to load rides");
      }
    } catch (e) {
      throw Exception('Failed to load rides: $e');
    }
  }
}
