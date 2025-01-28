import 'package:flutter/material.dart';

class TtextTheme {
  TtextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFFFFF8F0),
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Color(0xFFFFF8F0),
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Color(0xFFFFF8F0),
    ),
    titleLarge: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Color(0xFFFFF8F0),
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFF8F0),
    ),
    titleSmall: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFF8F0),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFF8F0),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Color(0xFFFFF8F0),
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.white.withOpacity(0.5),
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Color(0xFFFFF8F0),
    ),
    labelMedium: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Color(0xFFFFF8F0),
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.white.withOpacity(0.5),
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white.withOpacity(0.5),
    ),
  );
}
