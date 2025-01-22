// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class STextFormFieldTheme {
  STextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Color(0xFFDA90A4),
    suffixIconColor: Color(0xFFDA90A4),
    labelStyle: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 14,
      color: Colors.black,
    ),
    hintStyle: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 14,
      color: Colors.black,
    ),
    errorStyle: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontStyle: FontStyle.normal,
    ),
    floatingLabelStyle: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      color: Colors.black.withOpacity(0.8),
    ),
    border: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Color(0xFFDA90A4)),
    ),
    focusedBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Color(0xFFDA90A4)),
    ),
    errorBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 2, color: Colors.orange),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 14,
      color: Colors.white,
    ),
    hintStyle: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontSize: 14,
      color: Colors.white,
    ),
    errorStyle: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      fontStyle: FontStyle.normal,
    ),
    floatingLabelStyle: TextStyle(
      fontFamily: 'Poppins', // Use locally bundled Poppins font
      color: Colors.white.withOpacity(0.8),
    ),
    border: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.white),
    ),
    errorBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 2, color: Colors.orange),
    ),
  );
}
