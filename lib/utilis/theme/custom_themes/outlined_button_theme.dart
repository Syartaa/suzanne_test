import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class SOutlinedButtonTheme {
  SOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.black,
      side: const BorderSide(
        color: Color(0xFF00FFC2),
        width: 2.5,
      ), // Vibrant Pinkish Red
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      textStyle: TextStyle(
        fontFamily: 'Poppins', // Use locally bundled Poppins font
        fontSize: 16,
        color: AppColors.secondaryColor,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );
}
