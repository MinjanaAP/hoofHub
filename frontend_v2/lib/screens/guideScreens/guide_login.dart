import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/signup_text_feild.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/theme.dart';
import 'package:logger/web.dart';

class GuideLogin extends StatefulWidget {
  const GuideLogin({super.key});

  @override
  State<GuideLogin> createState() => _GuideLoginState();
}

class _GuideLoginState extends State<GuideLogin> {
  late String errorText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    errorText = '';
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        title: "hoofHub",
        showBackButton: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF723594), Color(0xFF8f4ab8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(40)),
                    ),
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        "assets/images/horse-3.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 32,
                    left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Login to continue your journey as a guide',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SingleChildScrollView(
                              padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              child: Column(
              children: [
                Form(
                    child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: "Enter your email",
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email.";
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                            .hasMatch(value)) {
                          return "Enter a valid email address.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    const Text(
                      "Password",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary),
                    ),
                    const SizedBox(height: 7.0),
                    CustomTextFormField(
                      hintText: "Enter your password.",
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 21.0,
                    ),
                    if (errorText.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            errorText,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12.0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ))
              ],
                              ),
                            )
            ],
          ),
        ),
      )),
    );
  }
}
