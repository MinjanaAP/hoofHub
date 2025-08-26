import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:frontend/common/foreground_alert.dart';
import 'package:frontend/constant/stripe_constants.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/models/guide_model.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/guideScreens/guide_home.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/select_profile.dart';
import 'package:frontend/screens/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void showForegroundDialog(String? title, String? body) {
  if (navigatorKey.currentContext != null) {
    // showDialog(
    //   context: navigatorKey.currentContext!,
    //   builder: (_) => AlertDialog(
    //     title: Text(title ?? 'Notification'),
    //     content: Text(body ?? 'You have a new update.'),
    //     actions: [
    //       TextButton(
    //         child: const Text("OK"),
    //         onPressed: () => Navigator.of(navigatorKey.currentContext!).pop(),
    //       ),
    //     ],
    //   ),
    // );

    showCustomDialog(
      context: navigatorKey.currentContext!,
      title: title ?? 'Notification',
      body: body ?? 'You have a new update.',
      buttonText: 'OK',
      onConfirm: () {
        Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _stripeSetup();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  // 🔊 Listen to messages when app is in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showForegroundDialog(
        message.notification!.title,
        message.notification!.body,
      );
    }
  });

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProviders()),
          ChangeNotifierProvider(create: (_) => GuideModel()),
          ChangeNotifierProvider(create: (_) => BookingProvider()),
          Provider(
              create: (_) => Dio()..options.baseUrl = ApiConstants.baseUrl),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      builder: DevicePreview.appBuilder,
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.startingPage,
      routes: AppRoutes.routes,
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    final auth = FirebaseAuth.instance;
    final dio = Provider.of<Dio>(context, listen: false);

    try {
      final user = auth.currentUser;
      if (user == null) {
        _navigateTo(const SelectProfile());
        return;
      }

      await user.getIdToken(true);
      final response = await dio.get('/users/role/${user.uid}');

      if (response.statusCode == 200 && response.data['status'] == true) {
        final role = response.data['role'];
        switch (role) {
          case 'guide':
            _navigateTo(const GuideHome());
            break;
          case 'rider':
            _navigateTo(const HomeScreen());
            break;
          default:
            _navigateTo(const SelectProfile());
        }
      } else {
        _navigateTo(const SelectProfile());
      }
    } catch (e) {
      logger.e("Authentication check error: $e");
      _navigateTo(const SelectProfile());
    }
  }

  void _navigateTo(Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

Future<void> _stripeSetup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
}
