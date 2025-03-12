import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/provider/favorite_provider.dart';
import 'package:suzanne_podcast_app/provider/playlist_provider.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';

void showFavoritePlaylistPopup(
    BuildContext context, WidgetRef ref, String podcastId) {
  final userState = ref.read(userProvider);
  final isLoggedIn = userState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (error, stackTrace) => false,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, child) {
          // Watch for favorite state updates
          final favorites = ref.watch(favoriteProvider);
          final isFavorited = favorites.contains(podcastId);

          return Container(
            padding:
                EdgeInsets.all(ScreenSize.width * 0.05), // Responsive padding
            decoration: BoxDecoration(
              color: Colors.black,
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
                    size: ScreenSize.width * 0.08, // Responsive icon size
                  ),
                  title: Text(
                    isFavorited
                        ? AppLocalizations.of(context)!.remove_from_favorite
                        : AppLocalizations.of(context)!.add_to_favorite,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenSize.width * 0.04, // Responsive text size
                    ),
                  ),
                  onTap: () {
                    if (!isLoggedIn) {
                      Navigator.of(context).pop(); // Close the modal
                      _showLoginMessage(context);
                    } else {
                      // Toggle favorite and close the modal after that
                      ref
                          .read(favoriteProvider.notifier)
                          .toggleFavorite(podcastId);
                      Navigator.of(context)
                          .pop(); // Close the modal after toggling
                    }
                  },
                ),
                // "Add to Playlist" option
                ListTile(
                  leading: Icon(
                    Icons.playlist_add,
                    color: Colors.white,
                    size: ScreenSize.width * 0.08, // Responsive icon size
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.add_to_playlist,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenSize.width * 0.04, // Responsive text size
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the modal first
                    if (!isLoggedIn) {
                      _showLoginMessage(context);
                    } else {
                      showPlaylistPopup(context, ref, podcastId);
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void showPlaylistPopup(BuildContext context, WidgetRef ref, String podcastId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, child) {
          final playlistsState = ref.watch(playlistProvider);

          return Container(
            padding:
                EdgeInsets.all(ScreenSize.width * 0.05), // Responsive padding
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(
                      ScreenSize.width * 0.04), // Responsive padding
                  child: Text(
                    AppLocalizations.of(context)!.select_playlist,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenSize.width * 0.05, // Responsive text size
                    ),
                  ),
                ),

                // Show Playlists if Available
                if (playlistsState.isNotEmpty)
                  ...playlistsState.map((playlist) {
                    final playlistName = playlist['name'] ?? 'Unnamed Playlist';
                    return ListTile(
                      leading: Icon(
                        Icons.playlist_add_check,
                        color: Colors.white,
                        size: ScreenSize.width * 0.08, // Responsive icon size
                      ),
                      title: Text(
                        playlistName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              ScreenSize.width * 0.04, // Responsive text size
                        ),
                      ),
                      onTap: () {
                        Future.delayed(Duration.zero, () {
                          if (context.mounted) {
                            ref
                                .read(playlistProvider.notifier)
                                .addPodcastToPlaylist(
                                    playlist['id'].toString(), podcastId);
                            Navigator.of(context).pop();
                          }
                        });
                      },
                    );
                  }).toList()
                else
                  Padding(
                    padding: EdgeInsets.all(
                        ScreenSize.width * 0.04), // Responsive padding
                    child: Text(
                      AppLocalizations.of(context)!.no_playlists,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize:
                            ScreenSize.width * 0.04, // Responsive text size
                      ),
                    ),
                  ),

                // Always Show "Create New Playlist"
                ListTile(
                  leading: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: ScreenSize.width * 0.08, // Responsive icon size
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.create_new_playlist,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenSize.width * 0.04, // Responsive text size
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showCreatePlaylistDialog(context, ref, podcastId);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void _showCreatePlaylistDialog(
    BuildContext context, WidgetRef ref, String podcastId) {
  final TextEditingController controller = TextEditingController();

  // Capture the provider's notifier before showing the dialog
  final playlistNotifier = ref.read(playlistProvider.notifier);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          AppLocalizations.of(context)!.create_new_playlist,
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenSize.width * 0.05, // Responsive text size
          ),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enter_playlist_name,
            hintStyle: TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog only
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenSize.width * 0.04, // Responsive text size
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final playlistName = controller.text.trim();
              if (playlistName.isNotEmpty) {
                playlistNotifier.createPlaylist(playlistName);
                playlistNotifier.addPodcastToPlaylist(playlistName, podcastId);

                Navigator.of(context).pop(); // Close dialog

                // Reopen the playlist popup after a short delay
                Future.delayed(Duration(milliseconds: 300), () {
                  if (context.mounted) {
                    showPlaylistPopup(context, ref, podcastId);
                  }
                });
              }
            },
            child: Text(
              AppLocalizations.of(context)!.create,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenSize.width * 0.04, // Responsive text size
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Show a login message when user is not logged in
void _showLoginMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(AppLocalizations.of(context)!.login_message),
    ),
  );
}
