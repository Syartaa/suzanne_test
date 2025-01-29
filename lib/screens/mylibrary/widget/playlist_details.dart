import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistName;
  final List playlistPodcasts;

  const PlaylistDetailScreen({
    Key? key,
    required this.playlistName,
    required this.playlistPodcasts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        centerTitle: true, // Centers the title horizontally
        title: Text(
          playlistName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 24,
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
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the back icon color to white
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: playlistPodcasts.length,
        itemBuilder: (context, index) {
          final podcast = playlistPodcasts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Color.fromARGB(255, 231, 32, 32),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  podcast['thumbnail'] ?? 'assets/images/banner4.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                podcast['title'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                podcast['host_name'],
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.secondaryColor,
                ),
                onPressed: () {
                  // Add logic to remove podcast from playlist
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
