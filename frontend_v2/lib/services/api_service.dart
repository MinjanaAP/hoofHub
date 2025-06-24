import 'dart:convert';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = "${ApiConstants.baseUrl}";
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      // connectTimeout: const Duration(seconds: 10),
      // receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<Map<String, dynamic>> getGuideById(String id) async {
    try {
      final response = await dio.get(
        '/guides/$id',
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch guide details: $e');
    }
  }

  static Future<String?> getData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body)['message'];
      } else {
        return "Error: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}
