import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/signup_text_feild.dart';
import 'package:frontend/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());

      // Show success alert
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text(
              'Password reset email has been sent. Please check your inbox.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back to login
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong. Please try again.';
      if (e.code == 'user-not-found') {
        message = 'No account found with this email.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address.';
      }

      // Show error alert
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        title: 'hoofhub',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter your email account to reset password.",
                    style: TextStyle(
                        color: Colors.black54, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Email Recovery",
                    style: TextStyle(
                        color: Color.fromARGB(137, 158, 156, 156),
                        fontFamily: 'Poppins',
                        fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/Forgot_password.png',
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    hintText: "Enter your email",
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.primary,
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _sendPasswordResetEmail,
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Poppins'),
                          ),
                        ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                        style: TextStyle(
                            color: Colors.black54, fontFamily: 'Poppins')),
                  ),
                  const SizedBox(height: 24),
                  const Text("Don’t have an account? Sign Up",
                      style: TextStyle(color: AppColors.primary)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
