import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/navigation_menu.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/screens/authentification/signup/signup_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

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
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Image(image: AssetImage("assets/logo/logo1.png")),
                  const SizedBox(height: 20),
                  Text(
                    loc.welcome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    loc.login_subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
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
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
