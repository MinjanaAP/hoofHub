import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/hoof_ride_text.dart';
import 'package:frontend/common/signup_text_feild.dart';
import 'package:frontend/theme.dart';

class RiderSignUp extends StatefulWidget {
  const RiderSignUp({super.key});

  @override
  State<RiderSignUp> createState() => _RiderSignUpState();
}

class _RiderSignUpState extends State<RiderSignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: HoofHubText(),
              ),
              const Row(
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
              // const SizedBox(height: 21),
              // const Center(
              //   child: Text(
              //     "Sign Up",
              //     style: TextStyle(
              //         fontSize: 24.0,
              //         fontWeight: FontWeight.w300,
              //         color: AppColors.primary,
              //         fontFamily: 'Poppins',
              //         shadows: [
              //           Shadow(
              //               offset: Offset(0, 4),
              //               blurRadius: 4,
              //               color: Color.fromRGBO(0, 0, 0, 0.25))
              //         ]),
              //   ),
              // ),
              const SizedBox(
                height: 21.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Full Name",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 7.0,
                      ),
                      CustomTextFormField(
                        hintText: "Enter your name here.",
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your full name.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 21.0,
                      ),
                      const Text(
                        "Email Address",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 7.0,
                      ),
                      CustomTextFormField(
                        hintText: "Enter your email address.",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter your email.";
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
                        height: 21.0,
                      ),
                      const Text(
                        "Mobile Number",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 7.0,
                      ),
                      CustomTextFormField(
                        hintText: "Enter your mobile number.", 
                        controller: mobileNumberController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your mobile number.";
                          } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return "Enter a valid 10-digit mobile number.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 21.0,
                      ),
                      const Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 7.0,
                      ),
                      CustomTextFormField(
                        hintText: "Enter your password.", 
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a password.";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters long.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 21.0,
                      ),
                      const Text(
                        "Confirm Password",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 7.0,
                      ),
                      CustomTextFormField(
                        hintText: "Re-enter your Password.", 
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password.";
                          }
                          if (value != passwordController.text) {
                            return "Passwords do not match.";
                          }
                          return null;
                        },
                        prefixIcon: Icons.lock,
                      ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, proceed with submission
                              print("Full Name: ${nameController.text}");
                              print("Email: ${emailController.text}");
                              print("Password: ${passwordController.text}");
                              // Add your signup logic here
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.black,
                            elevation: 8,
                          ),
                          child: const Text('SignUp'),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text(
                          'Already have an account ?',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            color: AppColors.primary
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary
                          ),
                        ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
