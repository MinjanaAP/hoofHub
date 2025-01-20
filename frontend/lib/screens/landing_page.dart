import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            const SizedBox(height: 16.0), 
            Image.asset('assets/images/logo.png'),
            const Text(
              "hoofHub",
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Color.fromARGB(255, 114, 53, 147),
                fontFamily: 'Poppins',
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
