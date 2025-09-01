import 'package:flutter/material.dart';

class CustomLoadingScreen extends StatefulWidget {
  const CustomLoadingScreen({Key? key}) : super(key: key);

  @override
  _CustomLoadingScreenState createState() => _CustomLoadingScreenState();
}

class _CustomLoadingScreenState extends State<CustomLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); 

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // or use your theme color
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/loading-logo.png',
                width: 250,
                height: 250,
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
      ),
    );
  }
}
