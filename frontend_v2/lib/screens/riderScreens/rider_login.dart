import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/hoof_ride_text.dart';
import 'package:frontend/common/signup_text_feild.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class RiderLoginScreen extends StatefulWidget {
  const RiderLoginScreen({super.key});

  @override
  State<RiderLoginScreen> createState() => _RiderLoginScreenState();
}

class _RiderLoginScreenState extends State<RiderLoginScreen> {
  late String errorText;

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

  Future<void> loginUser() async {
    setState(() {
      errorText = '';
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      logger.i("Login successful: ${userCredential.user!.email}");
      //? Navigate to home screen
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case "invalid-credential":
          errorMessage = "Invalid email or password.";
          break;
        case "user-not-found":
          errorMessage = "No user found with this email.";
          break;
        case "wrong-password":
          errorMessage = "Incorrect email or password.";
          break;
        case "user-disabled":
          errorMessage = "This account has been disabled.";
          break;
        case "too-many-request":
          errorMessage = "Too many login attempts. Try again later.";
          break;
        default:
          errorMessage = "Login failed : ${e.message}";
      }
      logger.e("Login failed : ${e}");

      setState(() {
        errorText = errorMessage;
      });
    } catch (e) {
      logger.e("Login Failed: $e");
      setState(() {
        errorText = "An unexpected error occurred. Please try again.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("An unexpected error occurred. Please try again.")),
      );
    }
  }

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
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: HoofHubText(),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "sign in",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "to enjoy your horse ride.",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 21),
                const Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w300,
                        color: AppColors.primary,
                        fontFamily: 'Poppins',
                        shadows: [
                          Shadow(
                              offset: Offset(0, 4),
                              blurRadius: 4,
                              color: Color.fromRGBO(0, 0, 0, 0.25))
                        ]),
                  ),
                ),
                const SizedBox(height: 21),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(20, 114, 53, 148),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 20.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "User Name",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary),
                              ),
                              const SizedBox(height: 7.0),
                              CustomTextFormField(
                                hintText: 'Your email here.',
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
                              SizedBox(
                                width: double.infinity,
                                height: 48.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.black,
                                    elevation: 8,
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      loginUser();
                                    }
                                  },
                                  child: const Text("Login"),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 21.0,
                ),
                const Text(
                  "Forgot Password ?",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account ? ',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 21.0,
                ),
                const Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(
                  height: 21.0,
                ),
                const Text(
                  'Login with social account',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w300,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  color: Color.fromARGB(23, 114, 53, 148),
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(
                  height: 21.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            print('Google');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Image.asset('assets/images/g.png',
                                    fit: BoxFit.contain),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              const Text('Google'),
                            ],
                          )),
                      ElevatedButton(
                          onPressed: () {
                            print('FaceBook');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Image.asset('assets/images/facebook.png',
                                    fit: BoxFit.contain),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              const Text('FaceBook'),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
