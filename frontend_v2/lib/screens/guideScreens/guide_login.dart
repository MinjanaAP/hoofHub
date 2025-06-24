import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/signup_text_feild.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/home_screen.dart';
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

  Future<void> guideLogin() async {
    setState(() {
      errorText = '';
      _isLoading = true;
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      logger.i("Login successful: ${userCredential.user!.email}");
      //? Navigate to home screen
      // Navigator.pushReplacementNamed(context, HomeScreen());
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const HomeScreen()));
      Navigator.pushReplacementNamed(context, AppRoutes.guideHome);
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
    } finally {
      _isLoading = false;
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
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 21,
                            ),
                            const Text(
                              "Email",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary),
                            ),
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
                                  fontSize: 16.0,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                                    guideLogin();
                                  }
                                },
                                child: _isLoading
                                    ? const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Login..."),
                                          SizedBox(width: 10),
                                          CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ],
                                      )
                                    : const Text("Login"),
                              ),
                            ),
                          ],
                        )),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Don’t have an account ? ',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.guideSignup);
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
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
