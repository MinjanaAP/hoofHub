import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
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
    final User? user = FirebaseAuth.instance.currentUser;

    ImageProvider profileImage;

    if (user?.photoURL != null) {
      profileImage = NetworkImage(user!.photoURL!);
    } else {
      profileImage = const AssetImage('assets/images/avatar-sample.jpg');
    }
    return AppBar(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 1),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "hoof",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
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
                      color: Colors.white,
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
                ),
              ],
            ),
            user != null
                ? IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.riderProfile);
                    },
                    icon: CircleAvatar(
                      backgroundImage: profileImage,
                      radius: 20,
                    ))
                : ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.selectProfile);
                    },
                    label: const Text("Login"))
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
