import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/riderScreens/rider_login.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startProgress(); 
  }

  void _startProgress() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) { 
      setState(() {
        _progress += 0.05; 

        if (_progress >= 1.0) {
          timer.cancel();
          _navigateToNextPage();
        }
      });
    });
  }

  void _navigateToNextPage() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.riderLogin
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                Image.asset('assets/images/logoColor.png'),
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
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter, 
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), 
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  color: const Color.fromARGB(255, 114, 53, 147), 
                  minHeight: 2, 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
