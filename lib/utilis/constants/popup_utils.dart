import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/favorite_provider.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';

void showFavoritePlaylistPopup(
    BuildContext context, WidgetRef ref, String podcastId) {
  final userState = ref.read(userProvider);
  final isLoggedIn = userState.value != null; // Check if user is logged in
  final favorites = ref.watch(favoriteProvider);
  final isFavorited = favorites.contains(podcastId);

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
            // "Add to Playlist" option (placeholder for future implementation)
            const ListTile(
              leading: Icon(Icons.playlist_add, color: Colors.white),
              title: Text('Add to Playlist',
                  style: TextStyle(color: Colors.white)),
              onTap: null, // TODO: Implement playlist logic
            ),
          ],
        ),
      );
    },
  );
}
