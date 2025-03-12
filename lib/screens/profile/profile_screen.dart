import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:suzanne_podcast_app/constants/banner_widget.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/provider/locale_provider.dart';
import 'package:suzanne_podcast_app/provider/notifications_provider.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/screens/authentification/login/login_screen.dart';
import 'package:suzanne_podcast_app/screens/profile/notification_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final languageNotifier = ref.watch(localeProvider.notifier);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        centerTitle: true,
        title: Text(
          loc.profile,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: ScreenSize.width > 600
                ? 26
                : 24, // Adjust font size based on screen width
            color: const Color(0xFFFFF8F0),
            shadows: [
              const Shadow(
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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Iconsax.global, color: Colors.white),
            color: const Color.fromARGB(255, 32, 32, 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            onSelected: (String language) {
              languageNotifier.setLocale(language);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'en',
                  child: Text("English",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                PopupMenuItem(
                  value: 'sq',
                  child: Text("Albanian",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                ScreenSize.width > 600 ? 24 : 16.0, // Adjust horizontal padding
          ),
          child: userState.when(
            data: (user) {
              if (user != null) {
                print(
                    'User loaded: firstName: ${user.firstName}, lastName: ${user.lastName}, email: ${user.email}');
              }

              if (user == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: ScreenSize.width > 600
                            ? 120
                            : 100, // Adjust icon size
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        loc.user_not_found,
                        style: TextStyle(
                          fontSize: ScreenSize.width > 600
                              ? 26
                              : 24, // Adjust text size
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        loc.please_log_in,
                        style: const TextStyle(
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
                            children: [
                              Icon(Iconsax.login, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                loc.login,
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
                      children: [
                        CircleAvatar(
                          radius: ScreenSize.width > 600
                              ? 60
                              : 50, // Adjust avatar size
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person,
                              size: ScreenSize.width > 600
                                  ? 60
                                  : 50, // Adjust icon size
                              color: AppColors.primaryColor),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              (user.firstName.isNotEmpty &&
                                      user.lastName.isNotEmpty)
                                  ? "${user.firstName} ${user.lastName}"
                                  : "Username",
                              style: TextStyle(
                                fontSize: ScreenSize.width > 600
                                    ? 24
                                    : 20, // Adjust text size
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
                    const SizedBox(height: 20),
                    BannerWidget(bannerType: 'main'),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final unreadCount =
                              ref.watch(notificationsProvider).when(
                                    data: (notifications) => notifications
                                        .where((n) => !n.isRead)
                                        .length,
                                    loading: () => 0,
                                    error: (_, __) => 0,
                                  );

                          return OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const NotificationScreen(),
                              ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Iconsax.notification,
                                    color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  loc.notifications,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (unreadCount > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      unreadCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
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
                            const Icon(Iconsax.logout, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              user == null ? loc.login : loc.logout,
                              style: const TextStyle(
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
