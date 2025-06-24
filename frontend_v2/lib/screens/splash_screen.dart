import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _textScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Logo fade-in
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Slogan scale-up
    _textScaleAnimation = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward().whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthCheck()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'assets/images/logoColor.png',
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "hoof",
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2.0,
                    color: Color.fromARGB(255, 114, 53, 147),
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  "Hub",
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: Color.fromARGB(255, 114, 53, 147),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Animated Slogan
            ScaleTransition(
              scale: _textScaleAnimation,
              child: Text(
                "Saddle Up & Ride!", 
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple[800],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Progress indicator
            SizedBox(
              width: 300,
              child: LinearProgressIndicator(
                backgroundColor: Colors.purple[100],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.purple[400]!,
                ),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
