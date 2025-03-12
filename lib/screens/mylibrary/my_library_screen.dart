import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/screens/mylibrary/widget/favorites_tab.dart';
import 'package:suzanne_podcast_app/screens/mylibrary/widget/playlist/playlist_tab.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class MyLibraryScreen extends StatelessWidget {
  const MyLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(198, 243, 18, 18),
          title: Center(
            child: Text(
              loc.myLibrary,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: ScreenSize.textScaler.scale(24), // Scaled font size
                color: Color(0xFFFFF8F0),
                shadows: [
                  Shadow(
                    color: Color(0xFFFFF1F1), // Drop shadow color (light pink)
                    offset: Offset(1.0, 1.0), // Shadow position
                    blurRadius: 3.0, // Blur effect for the shadow
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // TabBar outside the AppBar
            Container(
              color: const Color.fromARGB(
                  198, 243, 18, 18), // Background for the TabBar
              child: TabBar(
                labelColor: AppColors.secondaryColor,
                unselectedLabelColor: Color(0xFFFFF8F0),
                indicatorColor: AppColors.secondaryColor,
                indicatorWeight: 3.0,
                tabs: [
                  Tab(text: loc.favoritesTab),
                  Tab(text: 'Playlist'),
                ],
              ),
            ),
            SizedBox(height: 14 * ScreenSize.height / 800), // Scaled spacing
            // Expanded TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  FavoritesTab(),
                  PlaylistsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
