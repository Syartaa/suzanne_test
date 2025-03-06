import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/navigation_menu.dart';
import 'package:suzanne_podcast_app/screens/authentification/login/login_screen.dart';
import 'package:suzanne_podcast_app/screens/authentification/signup/signup_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!; // 🔹 Get translations

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Center(
                  child: Image(
                    image: AssetImage("assets/logo/logo1.png"),
                    width: 300,
                    height: 300,
                  ),
                ),
                SizedBox(height: 15.0),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    child: Text(
                      localization.welcome_login, // 🔹 Use translation
                      style: TextStyle(color: AppColors.secondaryColor),
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SignUpScreen()));
                    },
                    child: Text(
                      localization.welcome_signup, // 🔹 Use translation
                      style: TextStyle(color: AppColors.secondaryColor),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  localization.welcome_no_account, // 🔹 Use translation
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => NavigationMenu()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                    ),
                    child: Text(
                      localization.welcome_continue_guest, // 🔹 Use translation
                      style: TextStyle(
                          color: const Color.fromARGB(211, 43, 43, 43)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
