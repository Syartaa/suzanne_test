import 'package:flutter/widgets.dart';

class ScreenSize {
  static late double width;
  static late double height;
  static late TextScaler textScaler;

  static void init(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    textScaler = MediaQuery.of(context)
        .textScaler; // ✅ Use textScaler instead of textScaleFactor
  }
}
