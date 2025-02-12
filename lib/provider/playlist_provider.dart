import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class PlaylistNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  PlaylistNotifier(this.ref) : super([]) {
    fetchAllPlaylists();
  }

  final Ref ref;
  final ApiService _apiService = ApiService();

  // Flag to check if playlists are already loaded
  bool _playlistsLoaded = false;

  // New state for the selected playlist
  Map<String, dynamic>? _selectedPlaylist;
  Map<String, dynamic>? get selectedPlaylist => _selectedPlaylist;

  // Fetch all playlists from the API
  Future<void> fetchAllPlaylists() async {
    if (_playlistsLoaded) return; // Prevent multiple calls
    final userState = ref.read(userProvider);
    if (userState.value == null) return;

    final authToken = userState.value!.token;
    try {
      final playlists = await _apiService.getAllPlaylists(authToken!);
      print("Fetched Playlists: $playlists"); // Debugging
      state = playlists; // Update state with fetched playlists
      _playlistsLoaded = true; // Mark playlists as loaded
    } catch (e) {
      print("Error fetching playlists: $e");
    }
  }

  // Fetch a specific playlist by ID
  Future<void> fetchPlaylistById(String playlistId) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) return;

    final authToken = userState.value!.token;
    try {
      final playlist = await _apiService.getPlaylistById(
          playlistId: playlistId, authToken: authToken!);

      // ✅ Ensure selectedPlaylist is correctly set
      _selectedPlaylist = playlist['data'] ?? playlist;
      print(_selectedPlaylist);

      // Update state to reflect changes
      state = [
        for (final p in state)
          if (p['id'] == playlistId) _selectedPlaylist! else p
      ];
    } catch (e) {
      print("Error fetching playlist by ID: $e");
    }
  }

  // Reset playlists when user logs out
  void resetPlaylists() {
    state = [];
    _playlistsLoaded = false; // Reset loaded flag
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
        playlistId: playlistId,
        podcastId: podcastId,
        authToken: authToken!,
      );

      // ✅ Update state immediately without refetching
      state = [
        for (final playlist in state)
          if (playlist['id'].toString() == playlistId)
            {
              ...playlist,
              'podcasts': (playlist['podcasts'] as List)
                  .where((podcast) => podcast['id'].toString() != podcastId)
                  .toList(),
            }
          else
            playlist
      ];
    } catch (e) {
      print("Error removing podcast from playlist: $e");
      throw e;
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
}

// Define provider
final playlistProvider =
    StateNotifierProvider<PlaylistNotifier, List<Map<String, dynamic>>>((ref) {
  return PlaylistNotifier(ref);
});
