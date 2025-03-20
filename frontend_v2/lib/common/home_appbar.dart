import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/theme.dart';
import 'package:logger/web.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ? const CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage('assets/images/profilePic.jpg'),
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.riderLogin);
                    },
                    label: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
