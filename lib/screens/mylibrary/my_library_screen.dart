import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class MyLibraryScreen extends StatelessWidget {
  const MyLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(198, 243, 18, 18),
          title: Center(
            child: Text(
              "My Library",
              style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
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
                // indicator: BoxDecoration(
                //   color: AppColors.secondaryColor,
                //   borderRadius:
                //       BorderRadius.circular(.0), // Rounded indicator
                // ),
                labelColor: AppColors.secondaryColor,
                unselectedLabelColor: Colors.black,

                tabs: const [
                  Tab(text: 'Favorites'),
                  Tab(text: 'Playlist'),
                  Tab(text: 'Downloads'),
                ],
              ),
            ),
            SizedBox(height: 14),
            // Expanded TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  FavoritesTab(),
                  PlaylistTab(),
                  DownloadsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 5.0), // Margin around each tile
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 231, 32, 32),
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(10), // Padding inside the ListTile
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/banner4.png', // Your image here
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "Podcast Title $index", // Replace with actual title
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 37, 37, 37),
                ),
              ),
              subtitle: const Text(
                "Subtitle", // Replace with actual subtitle
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryColor,
                ),
              ),
              trailing: Icon(
                Icons.bookmark,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

class PlaylistTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Playlist Content",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class DownloadsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Downloads Content",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
