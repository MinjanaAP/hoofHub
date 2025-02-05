import 'package:flutter/material.dart';
import 'package:frontend/screens/landing_page.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3),(){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder:(context) => const LandingPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 114, 53, 147),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            Image.asset('assets/images/logo-w.png'),
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
                    color: Color.fromARGB(255, 250, 250, 250),
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  "Hub",
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
