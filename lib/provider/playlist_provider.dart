import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class PlaylistNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  PlaylistNotifier(this.ref) : super([]) {
    fetchAllPlaylists();
  }

  final Ref ref;
  final ApiService _apiService = ApiService();

  // Fetch all playlists from the API
  Future<void> fetchAllPlaylists() async {
    final userState = ref.read(userProvider);
    if (userState.value == null) return;

    final authToken = userState.value!.token;
    try {
      final playlists = await _apiService.getAllPlaylists(authToken!);
      print("Fetched Playlists: $playlists"); // Debugging
      state = [...playlists]; // Ensure UI updates
    } catch (e) {
      print("Error fetching playlists: $e");
    }
  }

  // Create a new playlist via API
  Future<void> createPlaylist(String playlistName) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) return;

    final authToken = userState.value!.token;
    try {
      final response = await _apiService.createPlaylist(
          name: playlistName, authToken: authToken!);

      if (response.containsKey('data')) {
        final newPlaylist = response['data'];
        state = [...state, newPlaylist]; // Add new playlist to state
      } else {
        print("Unexpected create playlist response: $response");
      }
    } catch (e) {
      print("Error creating playlist: $e");
    }
  }

  // Add podcast to a playlist
  Future<void> addPodcastToPlaylist(String playlistId, String podcastId) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) return;

    final authToken = userState.value!.token;
    try {
      await _apiService.addPodcastToPlaylist(
          playlistId: playlistId, podcastId: podcastId, authToken: authToken!);

      // Fetch updated playlist data
      await fetchAllPlaylists();
    } catch (e) {
      print("Error adding podcast to playlist: $e");
    }
  }

  // Remove podcast from a playlist
  Future<void> removePodcastFromPlaylist(
      String playlistId, String podcastId) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) return;

    final authToken = userState.value!.token;
    try {
      await _apiService.removePodcastFromPlaylist(
          playlistId: playlistId, podcastId: podcastId, authToken: authToken!);

      // Fetch updated playlist data
      await fetchAllPlaylists();
    } catch (e) {
      print("Error removing podcast from playlist: $e");
    }
  }

  // Get a specific playlist by ID
  Future<Map<String, dynamic>?> getPlaylistById(String playlistId) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) return null;

    final authToken = userState.value!.token;
    try {
      return await _apiService.getPlaylistById(
          playlistId: playlistId, authToken: authToken!);
    } catch (e) {
      print("Error fetching playlist by ID: $e");
      return null;
    }
  }

  // Reset playlists when user logs out
  void resetPlaylists() {
    state = [];
  }
}

// Define provider
final playlistProvider =
    StateNotifierProvider<PlaylistNotifier, List<Map<String, dynamic>>>((ref) {
  return PlaylistNotifier(ref);
});
