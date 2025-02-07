import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/provider/playlist_provider.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/screens/mylibrary/widget/playlist_details.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:shimmer/shimmer.dart';

class PlaylistsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistProvider); // Get playlists from API
    final userState = ref.watch(userProvider); // Watch user state
    final podcastState = ref.watch(podcastProvider); // Get podcast list

    // Trigger reload of playlists when user state changes (only once)
    if (userState.value != null && playlists.isEmpty) {
      ref.read(playlistProvider.notifier).fetchAllPlaylists();
    }

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: playlists.isEmpty
          ? _buildShimmerLoading() // Show shimmer effect when loading
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];

                // ✅ Use podcasts_count if podcasts list is missing
                final playlistPodcasts = (playlist['podcasts'] as List?) ?? [];
                final int podcastCount = playlistPodcasts.isNotEmpty
                    ? playlistPodcasts.length
                    : (playlist['podcasts_count'] ?? 0);

                final playlistName =
                    playlist['name'] as String? ?? "Unnamed Playlist";

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 231, 32, 32),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.secondaryColor,
                        ),
                        child: const Icon(
                          Icons.headset,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        playlistName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(242, 255, 248, 240),
                        ),
                      ),
                      subtitle: Text(
                        '$podcastCount Podcasts',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white70,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaylistDetailScreen(
                              playlistName: playlistName,
                              playlistPodcasts: playlistPodcasts.map((podcast) {
                                return {
                                  'id': podcast['id'],
                                  'title': podcast['title'],
                                  'thumbnail': podcast['thumbnail'],
                                  'audio_url': podcast['audio_url']
                                };
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Shimmer loading widget
  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5, // Show 5 placeholder items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: AppColors.primaryColor,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                title: Container(
                  width: 100,
                  height: 16,
                  color: Colors.white,
                ),
                subtitle: Container(
                  width: 70,
                  height: 12,
                  color: Colors.white,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
