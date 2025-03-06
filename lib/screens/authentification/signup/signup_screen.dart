import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/models/user.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/screens/authentification/login/login_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isMale = false;
  bool isFemale = false;

  void _handleGenderSelection(bool? value, String gender) {
    setState(() {
      if (gender == "Male") {
        isMale = value ?? false;
        isFemale = !isMale;
      } else if (gender == "Female") {
        isFemale = value ?? false;
        isMale = !isFemale;
      }
    });
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final gender = isMale
        ? "Male"
        : isFemale
            ? "Female"
            : null;

    if (gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a gender')),
      );
      return;
    }

    final user = User(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      gender: gender,
    );

    try {
      await ref.read(userProvider.notifier).registerUser(user);

      final state = ref.read(userProvider);

      if (state is AsyncData<User?> && state.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        _formKey.currentState!.reset();
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        setState(() {
          isMale = false;
          isFemale = false;
        });

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // 🔹 Get translations
    final userState = ref.watch(userProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userState is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userState.error.toString())),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and Welcome Text
                  const SizedBox(height: 15),
                  const Image(
                    image: AssetImage("assets/logo/logo1.png"),
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    loc.welcome_signup,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    loc.createAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  // Input Fields
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          decoration:
                              _inputDecoration(loc.firstName, Icons.person),
                          validator: (value) =>
                              value!.isEmpty ? loc.firstNameRequired : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: _inputDecoration(
                              loc.lastName, Icons.person_outline),
                          validator: (value) =>
                              value!.isEmpty ? loc.lastNameRequired : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration('Email', Icons.email),
                    validator: (value) {
                      if (value!.isEmpty) return loc.emailRequired;
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
                    decoration: _inputDecoration(loc.password_hint, Icons.lock),
                    validator: (value) {
                      if (value!.length < 6) {
                        return loc.passwordRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration:
                        _inputDecoration(loc.confirmPassword, Icons.lock),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return loc.passwordsNotMatch;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Gender Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isMale,
                            onChanged: (value) {
                              _handleGenderSelection(value, "Male");
                            },
                            activeColor: Colors.tealAccent,
                            checkColor: Colors.white,
                          ),
                          Text(
                            loc.male,
                            style: TextStyle(color: Colors.tealAccent),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: isFemale,
                            onChanged: (value) {
                              _handleGenderSelection(value, "Female");
                            },
                            activeColor: Colors.tealAccent,
                            checkColor: Colors.white,
                          ),
                          Text(
                            loc.female,
                            style: TextStyle(color: Colors.tealAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: userState is AsyncLoading ? null : _signUp,
                    child: userState is AsyncLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            loc.signUpButton,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loc.haveAccount,
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => LoginScreen()));
                        },
                        child: Text(
                          ' Login',
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
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.tealAccent),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.tealAccent),
      filled: true,
      fillColor: Colors.tealAccent.withOpacity(0.2),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.tealAccent),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.tealAccent),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
