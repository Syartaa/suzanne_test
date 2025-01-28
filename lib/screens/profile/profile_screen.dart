import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/screens/authentification/login/login_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        centerTitle: true,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Color(0xFFFFF8F0),
            shadows: [
              Shadow(
                color: Color(0xFFFFF1F1),
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: userState.when(
            data: (user) {
              if (user != null) {
                print(
                    'User loaded: firstName: ${user.firstName}, lastName: ${user.lastName}, email: ${user.email}');
              }

              //if the user is not login just as a guest
              if (user == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 100,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "User not found",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Please log in to continue.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Iconsax.login,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              (user.firstName != '' && user.lastName != '')
                                  ? "${user.firstName} ${user.lastName}"
                                  : "Username",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image(
                        image: AssetImage("assets/images/banner.jpg"),
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          if (user == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          } else {
                            ref.read(userProvider.notifier).logoutUser();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.logout,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              user == null ? "Login" : "Logout",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Iconsax.notification,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Notifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(
                "Error: $error",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
