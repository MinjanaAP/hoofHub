import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/api_service.dart';

class NotificationService {
  static Future<void> sendNotification(
      {required String uid,
      required String role,
      required String title,
      required String description}) async {
    try {
      final body = {
        'uid': uid,
        'role': role,
        'title': title,
        'description': description
      };

      final response =
          await ApiService.dio.post('/users/send-notifications', data: body);

      if (response.statusCode == 200) {
        logger.t('Notification send successfully to rider');
      } else {
        logger.e('Notification send failed');
      }
    } catch (e) {
      logger.e('Notification send failed :${e.toString()}');
    }
  }
}
