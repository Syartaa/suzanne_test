import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/playlist_provider.dart';
import 'package:suzanne_podcast_app/screens/mylibrary/widget/playlist_podcast_player.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
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
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: playlistPodcasts.length,
        itemBuilder: (context, index) {
          final podcast = playlistPodcasts[index];
          final podcastId = podcast['id'].toString();

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Color.fromARGB(255, 231, 32, 32),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: podcast['thumbnail'] != null
                    ? Image.network(
                        podcast['thumbnail'].startsWith('http')
                            ? podcast['thumbnail']
                            : 'https://suzanne-podcast.laratest-app.com/${podcast['thumbnail']}',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.podcasts,
                        size: 50,
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
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () async {
                  await _removePodcast(context, ref, playlistId, podcastId);
                },
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PlaylistPodcastPlayerScreen(
                      playlistName: playlistName,
                      playlistPodcasts:
                          List<Map<String, dynamic>>.from(playlistPodcasts),
                      startIndex: index,
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
