import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  runApp(
    DevicePreview(
      enabled: true, //! Set to false in production
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
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
