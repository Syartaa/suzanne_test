import 'package:flutter/material.dart';

class SElevetedButtonTheme {
  SElevetedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFF00FFC2), // Deep Purple
      disabledForegroundColor: Colors.grey,
      disabledBackgroundColor: Colors.grey,
      side: const BorderSide(color: Color(0xFF00FFC2)), // Deep Purple
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: TextStyle(
        fontFamily: 'Poppins', // Use locally bundled Poppins font
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );
}
