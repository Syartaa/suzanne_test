// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/navigation_menu.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Spread out the content
          children: [
            // Center part (Image and buttons)
            Column(
              children: [
                Center(
                  child: Image(
                    image: AssetImage("assets/logo/logo1.png"),
                    width: 300,
                    height: 300,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Login",
                      style: TextStyle(color: AppColors.secondaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: AppColors.secondaryColor),
                    ),
                  ),
                ),
              ],
            ),

            // Spacer or Bottom content
            Column(
              children: [
                Text(
                  "If you don’t have an account",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (cyx) => NavigationMenu()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                    ),
                    child: Text(
                      "Continue as a guest",
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
