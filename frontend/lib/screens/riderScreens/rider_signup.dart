import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/hoof_ride_text.dart';
import 'package:frontend/theme.dart';

class RiderSignUp extends StatefulWidget {
  const RiderSignUp({super.key});

  @override
  State<RiderSignUp> createState() => _RiderSignUpState();
}

class _RiderSignUpState extends State<RiderSignUp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: "hoofHub",
        showBackButton: true,
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: HoofHubText(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "sign up",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "to create hoof account.",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(height: 21),
            Center(
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  color: AppColors.primary,
                  fontFamily: 'Poppins',
                  shadows: [
                    Shadow(
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      color: Color.fromRGBO(0, 0, 0, 0.25)
                    )
                  ]
                ),
              ),
            ),
          ],
        )
      ),

    );
  }
}