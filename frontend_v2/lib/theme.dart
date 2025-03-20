import 'package:flutter/material.dart';

class AppColors {
  static const Color primary =Color.fromARGB(255, 114, 53, 147);
  static const Color secondary = Colors.amber;
  static const Color background = Colors.white;
  static const Color textColor = Colors.black87;
}

ThemeData lightTheme = ThemeData(

  primaryColor: AppColors.primary,

  scaffoldBackgroundColor: AppColors.background,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    titleTextStyle: TextStyle(color: AppColors.background, fontSize: 18, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: AppColors.background),
  ),


  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textColor),
    bodyMedium: TextStyle(color: AppColors.textColor),
  ),


  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),


);
