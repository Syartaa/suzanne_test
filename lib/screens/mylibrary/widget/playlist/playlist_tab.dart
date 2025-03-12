import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/provider/playlist_provider.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/screens/mylibrary/widget/playlist/playlist_details.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class PlaylistsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistProvider); // Get playlists from API
    final userState = ref.watch(userProvider); // Watch user state
    final loc = AppLocalizations.of(context)!;

    final isLoading =
        ref.watch(playlistProvider.notifier).playlistsLoaded == false;

    // Trigger reload of playlists when user state changes (only once)
    if (userState.value != null && playlists.isEmpty && !isLoading) {
      ref.read(playlistProvider.notifier).fetchAllPlaylists();
    }

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.secondaryColor,
              ),
            )
          : playlists.isEmpty
              ? Center(
                  child: Text(
                    loc.noPlaylistsAvailable,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ScreenSize.textScaler
                          .scale(16), // Responsive font size
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenSize.height * 0.02, // Responsive padding
                  ),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    final playlistId = playlist['id'].toString();
                    final playlistPodcasts =
                        (playlist['podcasts'] as List?) ?? [];
                    final int podcastCount = playlistPodcasts.isNotEmpty
                        ? playlistPodcasts.length
                        : (playlist['podcasts_count'] ?? 0);

                    final playlistName =
                        playlist['name'] as String? ?? "Unnamed Playlist";

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical:
                            ScreenSize.height * 0.01, // Responsive padding
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal:
                              ScreenSize.width * 0.02, // Responsive margin
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 231, 32, 32),
                          borderRadius: BorderRadius.circular(
                            ScreenSize.width * 0.03, // Responsive border radius
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(
                            ScreenSize.width * 0.03, // Responsive padding
                          ),
                          leading: Container(
                            width: ScreenSize.width * 0.15, // Responsive width
                            height:
                                ScreenSize.width * 0.15, // Responsive height
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                ScreenSize.width *
                                    0.02, // Responsive border radius
                              ),
                              color: AppColors.secondaryColor,
                            ),
                            child: Icon(
                              Icons.headset,
                              color: Colors.black,
                              size: ScreenSize.width *
                                  0.07, // Responsive icon size
                            ),
                          ),
                          title: Text(
                            playlistName,
                            style: TextStyle(
                              fontSize: ScreenSize.textScaler
                                  .scale(16), // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(242, 255, 248, 240),
                            ),
                          ),
                          subtitle: Text(
                            '$podcastCount Podcasts',
                            style: TextStyle(
                              fontSize: ScreenSize.textScaler
                                  .scale(12), // Responsive font size
                              color: Colors.white70,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white70,
                            size: ScreenSize.textScaler
                                .scale(16), // Responsive icon size
                          ),
                          onTap: () async {
                            final notifier =
                                ref.read(playlistProvider.notifier);
                            await notifier.fetchPlaylistById(playlistId);
                            final selectedPlaylist = notifier.selectedPlaylist;

                            if (selectedPlaylist != null) {
                              final playlistData =
                                  selectedPlaylist['data'] ?? selectedPlaylist;

                              final playlistName =
                                  playlistData['name']?.toString() ??
                                      "Unnamed Playlist";
                              final playlistPodcasts =
                                  (playlistData['podcasts'] as List?)
                                          ?.map((podcast) => {
                                                'id': podcast['id'],
                                                'title': podcast['title'],
                                                'thumbnail':
                                                    podcast['thumbnail'],
                                                'audio_url':
                                                    podcast['audio_url'],
                                                'host_name':
                                                    podcast['host_name']
                                              })
                                          .toList() ??
                                      [];

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaylistDetailScreen(
                                    playlistName: playlistName,
                                    playlistPodcasts: playlistPodcasts,
                                    playlistId: playlistId,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
