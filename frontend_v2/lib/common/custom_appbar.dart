import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return AppBar(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "hoof",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 250, 250, 250),
                fontFamily: 'Poppins',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                "hub",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 250, 250, 250),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(width: 5),
            Transform.rotate(
              angle: -11.89 * (pi / 180),
              child: SizedBox(
                height: 20,
                child: Image.asset('assets/images/logo-w.png',
                    fit: BoxFit.contain),
              ),
            )
          ],
        ),
      ),
      leading: showBackButton
          ? BackButton(
              onPressed: () => Navigator.pop(context),
              color: Colors.white,
          )
          : const SizedBox.shrink(),
      backgroundColor: AppColors.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
