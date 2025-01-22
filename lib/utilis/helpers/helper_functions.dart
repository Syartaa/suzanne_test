import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SHelperFunctions {
  static Color? getColor(String value) {
    value = value.toLowerCase(); // Ensure case-insensitivity

    if (value == 'green') {
      return Colors.green;
    } else if (value == 'blue') {
      return Colors.blue;
    } else if (value == 'red') {
      return Colors.red;
    } else if (value == 'yellow') {
      return Colors.yellow;
    } else if (value == 'orange') {
      return Colors.orange;
    } else if (value == 'purple') {
      return Colors.purple;
    } else if (value == 'pink') {
      return Colors.pink;
    } else if (value == 'brown') {
      return Colors.brown;
    } else if (value == 'black') {
      return Colors.black;
    } else if (value == 'white') {
      return Colors.white;
    } else if (value == 'grey' || value == 'gray') {
      return Colors.grey;
    } else if (value == 'teal') {
      return Colors.teal;
    } else if (value == 'cyan') {
      return Colors.cyan;
    } else if (value == 'amber') {
      return Colors.amber;
    }

    // Default to null if no match is found
    return null;
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void showAlert(String title, String message) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"))
            ],
          );
        });
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }
}
