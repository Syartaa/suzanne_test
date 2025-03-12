import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/navigation_menu.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/screens/authentification/signup/signup_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:flutter/widgets.dart'; // Import to access ScreenSize class

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  bool isLoading = false; // Manage loading state

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ScreenSize.width * 0.06), // Dynamic padding
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //SizedBox(height: ScreenSize.height * 0.01),
                const Image(image: AssetImage("assets/logo/logo1.png")),
                SizedBox(height: ScreenSize.height * 0.02),
                Text(
                  loc.welcome,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenSize.width * 0.08, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ScreenSize.height * 0.01),
                Text(
                  loc.login_subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenSize.width * 0.05, // Responsive font size
                  ),
                ),
                SizedBox(height: ScreenSize.height * 0.05),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.email, color: AppColors.secondaryColor),
                    hintText: loc.email_hint,
                    hintStyle: TextStyle(color: AppColors.secondaryColor),
                    filled: true,
                    fillColor: AppColors.secondaryColor.withOpacity(0.2),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: AppColors.secondaryColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.enter_email;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return loc.email_validation;
                    }
                    return null;
                  },
                ),
                SizedBox(height: ScreenSize.height * 0.03),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.lock, color: AppColors.secondaryColor),
                    hintText: loc.password_hint,
                    hintStyle: TextStyle(color: AppColors.secondaryColor),
                    filled: true,
                    fillColor: AppColors.secondaryColor.withOpacity(0.2),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: AppColors.secondaryColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.enter_password;
                    }
                    if (value.length < 6) {
                      return loc.password_validation;
                    }
                    return null;
                  },
                ),
                SizedBox(height: ScreenSize.height * 0.04),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenSize.height * 0.02), // Dynamic padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                              errorMessage = null;
                            });

                            final email = emailController.text;
                            final password = passwordController.text;
                            final loginResult = await ref
                                .read(userProvider.notifier)
                                .loginUser(email, password);

                            if (loginResult == 'Success') {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => NavigationMenu()),
                                (route) => false,
                              );
                            } else {
                              setState(() {
                                isLoading = false;
                                errorMessage = loginResult == 'User not found'
                                    ? loc.user_not_found
                                    : loginResult == 'Incorrect password'
                                        ? loc.incorrect_password
                                        : loc.unexpected_error;
                              });
                            }
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.secondaryColor)
                      : Text(
                          loc.login_button,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                ScreenSize.width * 0.05, // Adjust font size
                          ),
                        ),
                ),
                SizedBox(height: ScreenSize.height * 0.02),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                SizedBox(height: ScreenSize.height * 0.01),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loc.donthaveAccount,
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => SignUpScreen()));
                      },
                      child: Text(
                        ' Signup',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
