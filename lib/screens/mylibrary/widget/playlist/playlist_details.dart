import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/playlist_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class PlaylistDetailScreen extends ConsumerWidget {
  final String playlistId;
  final String playlistName;
  final List playlistPodcasts;

  const PlaylistDetailScreen({
    Key? key,
    required this.playlistId,
    required this.playlistName,
    required this.playlistPodcasts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        centerTitle: true,
        title: Text(
          playlistName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: ScreenSize.textScaler.scale(24), // Responsive font size
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
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(
          ScreenSize.width * 0.03, // Responsive padding
        ),
        itemCount: playlistPodcasts.length,
        itemBuilder: (context, index) {
          final podcast = playlistPodcasts[index];
          final podcastId = podcast['id'].toString();

          return Card(
            margin: EdgeInsets.symmetric(
              vertical: ScreenSize.height * 0.01, // Responsive margin
            ),
            color: const Color.fromARGB(255, 231, 32, 32),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(
                  ScreenSize.width * 0.02, // Responsive border radius
                ),
                child: podcast['thumbnail'] != null
                    ? Image.network(
                        podcast['thumbnail'].startsWith('http')
                            ? podcast['thumbnail']
                            : 'https://suzanne-podcast.laratest-app.com/${podcast['thumbnail']}',
                        width: ScreenSize.width * 0.15, // Responsive width
                        height: ScreenSize.width * 0.15, // Responsive height
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.podcasts,
                        size: ScreenSize.width * 0.1, // Responsive icon size
                      ),
              ),
              title: Text(
                podcast['title'],
                style: TextStyle(
                  fontSize:
                      ScreenSize.textScaler.scale(14), // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                podcast['host_name'],
                style: TextStyle(
                  color: Colors.white70,
                  fontSize:
                      ScreenSize.textScaler.scale(12), // Responsive font size
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: ScreenSize.textScaler.scale(20), // Responsive icon size
                ),
                onPressed: () async {
                  await _removePodcast(context, ref, playlistId, podcastId);
                },
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PodcastDetailsScreen(
                      podcast: podcast, // Pass the podcast details
                      playlist: playlistPodcasts.cast<Map<String, dynamic>>(),
                      playlistIndex:
                          index, // Pass the index to indicate it's from a playlist
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _removePodcast(BuildContext context, WidgetRef ref,
      String playlistId, String podcastId) async {
    final notifier = ref.read(playlistProvider.notifier);

    try {
      await notifier.removePodcastFromPlaylist(playlistId, podcastId);

      // ✅ No need to manually refresh the UI – state updates automatically
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Podcast removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove podcast: $e')),
      );
    }
  }
}
