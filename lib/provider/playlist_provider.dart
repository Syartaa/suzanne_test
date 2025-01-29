import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzanne_podcast_app/models/user.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';

class PlaylistNotifier extends StateNotifier<Map<String, List<String>>> {
  PlaylistNotifier(this.ref) : super({}) {
    loadPlaylists();
  }

  final Ref ref;

  // Load playlists from SharedPreferences based on the logged-in user
  Future<void> loadPlaylists() async {
    final userState = ref.watch(userProvider);
    final prefs = await SharedPreferences.getInstance();

    if (userState is AsyncData<User?> && userState.value != null) {
      final userId = userState.value!.id;
      final playlistsJson = prefs.getString('user_playlists_$userId');

      if (playlistsJson != null) {
        state = Map<String, List<String>>.from(
          json.decode(playlistsJson).map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              ),
        );
        print("Loaded playlists for user $userId: $state");
      } else {
        print("No playlists found for user $userId.");
      }
    } else {
      print("User not loaded yet or is null.");
    }
  }

  // Save playlists to SharedPreferences based on the logged-in user
  Future<void> _savePlaylists() async {
    final userState = ref.read(userProvider);
    final prefs = await SharedPreferences.getInstance();

    if (userState.value != null) {
      final userId = userState.value!.id;
      await prefs.setString('user_playlists_$userId', json.encode(state));
      print("Saved playlists for user $userId: $state");
    }
  }

  // Create a new playlist if it doesn't exist for the current user
  Future<void> createPlaylist(String playlistName) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) {
      print("User not logged in! Cannot create playlist.");
      return;
    }

    if (!state.containsKey(playlistName)) {
      state = {...state, playlistName: []};
      await _savePlaylists();
      print("Created new playlist: $playlistName");
    } else {
      print("Playlist already exists: $playlistName");
    }
  }

  // Add or remove a podcast from a playlist for the logged-in user
  Future<void> togglePodcastInPlaylist(
      String playlistName, String podcastId) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) {
      print("User not logged in! Cannot modify playlist.");
      return;
    }

    if (!state.containsKey(playlistName)) {
      print("Playlist does not exist: $playlistName");
      return;
    }

    final isInPlaylist = state[playlistName]!.contains(podcastId);
    if (isInPlaylist) {
      state[playlistName] =
          state[playlistName]!.where((id) => id != podcastId).toList();
      print("Removed podcast $podcastId from playlist $playlistName");
    } else {
      state[playlistName] = [...state[playlistName]!, podcastId];
      print("Added podcast $podcastId to playlist $playlistName");
    }

    await _savePlaylists();
  }

  // Reset playlists when user logs out
  Future<void> resetPlaylists(User? user) async {
    state = {}; // Clear the current playlists
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      final userId = user.id;
      await prefs
          .remove('user_playlists_$userId'); // Remove from SharedPreferences
      print("Reset playlists for user $userId");
    }
  }
}

final playlistProvider =
    StateNotifierProvider<PlaylistNotifier, Map<String, List<String>>>((ref) {
  return PlaylistNotifier(ref);
});
