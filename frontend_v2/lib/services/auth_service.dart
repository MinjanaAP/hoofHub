import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/api_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } catch (e) {
      print("Login Error : $e");
      return null;
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>> setupFCM(String uid, String role) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    //? for permission (iOS only)
    await messaging.requestPermission();

    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      throw Exception('Notification permission not granted');
    }

    String? token = await messaging.getToken();
    print("FCM Token: $token");

    if (token == null) {
      throw Exception('FCM token is null');
    }

    try {
      final body = {
        "uid": uid,
        "role": role,
        "fcmToken": token,
      };

      print("Sending FCM Token Update: $body");

      final response =
          await ApiService.dio.post('/users/fcm-token', data: body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'message':
              response.data['message'] ?? 'FCM token updated successfully',
        };
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to update FCM token');
      }
    } catch (e) {
      logger.e('Failed to update FCM token: ${e.toString()}');
      throw Exception('Failed to update FCM token: ${e.toString()}');
    }
  }
}
