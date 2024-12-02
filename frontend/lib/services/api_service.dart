import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5000/api";

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
