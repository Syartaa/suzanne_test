import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:suzanne_podcast_app/models/user.dart';
import 'package:suzanne_podcast_app/screens/discover/discover_screen.dart';
import 'package:suzanne_podcast_app/screens/home/home_screen.dart';
import 'package:suzanne_podcast_app/screens/live/live_screen.dart';
import 'package:suzanne_podcast_app/screens/mylibrary/my_library_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

final selectedIndexProvider = StateProvider((ref) => 0);

class NavigationMenu extends ConsumerWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the selected index from the provider
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: _getScreenForIndex(selectedIndex),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            // Update the selected index using provider
            ref.read(selectedIndexProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          selectedItemColor: Color.fromARGB(255, 131, 128, 128),
          unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
          showSelectedLabels: false, // Disable labels
          showUnselectedLabels: false, // Disable labels
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.discover),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_library),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.live_tv_outlined),
              label: '', // No label
            ),
          ],
        ),
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return DiscoverScreen();
      case 2:
        return MyLibraryScreen();
      case 3:
        return LiveScreen();
      default:
        return const HomeScreen();
    }
  }
}
