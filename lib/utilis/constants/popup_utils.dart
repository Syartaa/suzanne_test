import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/favorite_provider.dart';
import 'package:suzanne_podcast_app/provider/playlist_provider.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';

void showFavoritePlaylistPopup(
    BuildContext context, WidgetRef ref, String podcastId) {
  final userState = ref.read(userProvider);
  final isLoggedIn = userState.value != null; // Check if user is logged in
  final favorites = ref.watch(favoriteProvider);
  final isFavorited = favorites.contains(podcastId);
  final playlists = ref.watch(playlistProvider);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // "Add to Favorite" option
            ListTile(
              leading: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              title: Text(
                isFavorited ? 'Remove from Favorite' : 'Add to Favorite',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                if (!isLoggedIn) {
                  // Show alert if user is not logged in
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please log in to favorite podcasts.')),
                  );
                } else {
                  ref.read(favoriteProvider.notifier).toggleFavorite(podcastId);
                }
                Navigator.of(context).pop(); // Close the popup
              },
            ),
            // "Add to Playlist" option
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white),
              title: const Text('Add to Playlist',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop(); // Close the current popup
                showPlaylistPopup(context, ref, podcastId);
              },
            ),
          ],
        ),
      );
    },
  );
}

void showPlaylistPopup(BuildContext context, WidgetRef ref, String podcastId) {
  final playlists = ref.watch(playlistProvider);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Select Playlist or Create New',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ...playlists.keys.map((playlistName) {
              return ListTile(
                leading:
                    const Icon(Icons.playlist_add_check, color: Colors.white),
                title: Text(playlistName,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  ref
                      .read(playlistProvider.notifier)
                      .togglePodcastInPlaylist(playlistName, podcastId);
                  Navigator.of(context).pop(); // Close the popup
                },
              );
            }).toList(),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.white),
              title: const Text('Create New Playlist',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop(); // Close the current popup
                _showCreatePlaylistDialog(context, ref, podcastId);
              },
            ),
          ],
        ),
      );
    },
  );
}

void _showCreatePlaylistDialog(
    BuildContext context, WidgetRef ref, String podcastId) {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text(
          'Create a New Playlist',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter playlist name',
            hintStyle: TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              final playlistName = controller.text.trim();
              if (playlistName.isNotEmpty) {
                ref
                    .read(playlistProvider.notifier)
                    .createPlaylist(playlistName);
                ref
                    .read(playlistProvider.notifier)
                    .togglePodcastInPlaylist(playlistName, podcastId);
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Create',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
