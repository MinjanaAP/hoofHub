import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/guide_model.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/riderScreens/rider_login.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';
import 'package:frontend/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  runApp(
    DevicePreview(
      enabled: false, //! Set to false in production
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProviders()),
          ChangeNotifierProvider(create: (context) => GuideModel())
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
      builder: DevicePreview.appBuilder, // Add this to apply preview settings
      useInheritedMediaQuery: true, // Ensures media queries adapt to preview
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.startingPage,
      routes: AppRoutes.routes,
    );
  }
}

//? Auth check-------------------
class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // TODO : create loading page
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return  HomeScreen();
          } else {
            return const RiderLoginScreen();
          }
        });
  }
}