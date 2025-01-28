import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzanne_podcast_app/navigation_menu.dart';
import 'package:suzanne_podcast_app/screens/onboarding/onboarding_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]) // Lock to portrait mode
      .then((_) async {
    // Check if the user is logged in
    final isUserLoggedIn = await _checkUserLoggedIn();
    runApp(ProviderScope(child: MyApp(isUserLoggedIn: isUserLoggedIn)));
  });
}

Future<bool> _checkUserLoggedIn() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    return userData != null; // Returns true if user data exists
  } catch (e) {
    print("Error checking login status: $e");
    return false; // Default to not logged in on error
  }
}

class MyApp extends StatelessWidget {
  final bool isUserLoggedIn;

  const MyApp({Key? key, required this.isUserLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lighTheme,
      // Show ProfileScreen if the user is logged in; otherwise, OnboardingScreen
      home: isUserLoggedIn ? NavigationMenu() : const OnboardingScreen(),
    );
  }
}
