import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/models/guide_model.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/guideScreens/guide_home.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/riderScreens/rider_login.dart';
import 'package:frontend/screens/select_profile.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';
import 'package:frontend/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProviders()),
          ChangeNotifierProvider(create: (context) => GuideModel()),
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
        _navigateTo(const RiderLoginScreen());
        return;
      }

      // Check if token needs refresh
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
      print("Authentication check error: $e");
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
