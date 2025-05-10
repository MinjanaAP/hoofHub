import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const CustomTextFormField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration:  InputDecoration(
        hintText: hintText,
        hintStyle:const TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
          fontFamily: 'Poppins'
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
            color: Color(0xFF9CA2B5),
            width: 1.0,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
