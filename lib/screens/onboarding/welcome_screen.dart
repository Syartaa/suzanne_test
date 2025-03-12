import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/navigation_menu.dart';
import 'package:suzanne_podcast_app/screens/authentification/login/login_screen.dart';
import 'package:suzanne_podcast_app/screens/authentification/signup/signup_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!; // 🔹 Get translations

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: EdgeInsets.all(
          ScreenSize.width * 0.05, // Responsive padding
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Center(
                  child: Image(
                    image: const AssetImage("assets/logo/logo1.png"),
                    width: ScreenSize.width * 0.8, // Responsive width
                    height: ScreenSize.width * 0.8, // Responsive height
                  ),
                ),
                SizedBox(
                    height: ScreenSize.height * 0.02), // Responsive spacing
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: Text(
                      localization.welcome_login, // 🔹 Use translation
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: ScreenSize.textScaler
                            .scale(16), // Responsive font size
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: ScreenSize.height * 0.03), // Responsive spacing
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      localization.welcome_signup, // 🔹 Use translation
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: ScreenSize.textScaler
                            .scale(16), // Responsive font size
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  localization.welcome_no_account, // 🔹 Use translation
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        ScreenSize.textScaler.scale(14), // Responsive font size
                  ),
                ),
                SizedBox(
                    height: ScreenSize.height * 0.02), // Responsive spacing
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => NavigationMenu()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                    ),
                    child: Text(
                      localization.welcome_continue_guest, // 🔹 Use translation
                      style: TextStyle(
                        color: const Color.fromARGB(211, 43, 43, 43),
                        fontSize: ScreenSize.textScaler
                            .scale(16), // Responsive font size
                      ),
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
