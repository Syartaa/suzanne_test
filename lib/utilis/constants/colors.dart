import 'package:flutter/material.dart';

class SColor {
  SColor._();

  static const Color primaryColor = Color(0xFF4B68FF);
  static const Color secondary = Color.fromARGB(255, 243, 192, 81);
  static const Color accent = Color.fromARGB(255, 145, 162, 247);

  static const Gradient linearGradient = LinearGradient(
      begin: Alignment(0.0, 0.0),
      end: Alignment(0.707, -0.707),
      colors: [
        Color(0xffff9a9e),
        Color(0xfffad0c4),
        Color(0xfffad0c4),
      ]);

  static const Color textPrimary = Color.fromARGB(255, 105, 103, 103);
  static const Color textSecondary = Colors.grey;
  static const Color textWhite = Colors.white;

  static const Color light = Color.fromARGB(255, 240, 239, 239);
  static const Color dark = Color.fromARGB(255, 70, 69, 69);
  static const Color primaryBackground = Color.fromARGB(255, 196, 193, 193);

  // Button colors
  static const Color buttonPrimary = Color.fromARGB(255, 7, 134, 238);
  static const Color buttonSecondary = Color.fromARGB(255, 124, 125, 126);
  static const Color buttonDisabled = Color.fromARGB(255, 218, 220, 221);

  // Border colors
  static const Color borderPrimary = Color.fromARGB(255, 0, 102, 204);
  static const Color borderSecondary = Color.fromARGB(255, 169, 169, 169);
  static const Color borderError = Color.fromARGB(255, 255, 77, 77);

  // Error and validation colors
  static const Color error = Color.fromARGB(255, 255, 0, 0);
  static const Color warning = Color.fromARGB(255, 255, 165, 0);
  static const Color success = Color.fromARGB(255, 0, 128, 0);
  static const Color info = Color.fromARGB(255, 0, 123, 255);

  // Natural shades
  static const Color shadeLight = Color.fromARGB(255, 245, 245, 245);
  static const Color shadeMedium = Color.fromARGB(255, 200, 200, 200);
  static const Color shadeDark = Color.fromARGB(255, 105, 105, 105);
}
