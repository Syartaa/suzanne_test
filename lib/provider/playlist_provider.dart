import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class PlaylistNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  PlaylistNotifier(this.ref) : super([]) {
    fetchAllPlaylists();
  }

  final Ref ref;
  final ApiService _apiService = ApiService();

  bool _playlistsLoaded = false;
  Map<String, dynamic>? _selectedPlaylist;
  Map<String, dynamic>? get selectedPlaylist => _selectedPlaylist;

  // Tracks the current playlist being played
  Map<String, dynamic>? _currentPlaylist;
  List<dynamic> _currentPlaylistPodcasts = [];
  int _currentPodcastIndex = -1;

  Map<String, dynamic>? get currentPlaylist => _currentPlaylist;

  Future<void> fetchAllPlaylists() async {
    if (_playlistsLoaded) return;
    final userState = ref.read(userProvider);
    if (userState.value == null) return;

    final authToken = userState.value!.token;
    try {
      final playlists = await _apiService.getAllPlaylists(authToken!);
      state = playlists;
      _playlistsLoaded = true;
    } catch (e) {
      print("Error fetching playlists: $e");
    }
  }

  Future<void> fetchPlaylistById(String playlistId) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) return;

    final authToken = userState.value!.token;
    try {
      final playlist = await _apiService.getPlaylistById(
          playlistId: playlistId, authToken: authToken!);

      _selectedPlaylist = playlist['data'] ?? playlist;

      state = [
        for (final p in state)
          if (p['id'] == playlistId) _selectedPlaylist! else p
      ];
    } catch (e) {
      print("Error fetching playlist by ID: $e");
    }
  }

  void resetPlaylists() {
    state = [];
    _playlistsLoaded = false;
  }

  Future<void> createPlaylist(String playlistName) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) return;

    final authToken = userState.value!.token;
    try {
      final response = await _apiService.createPlaylist(
          name: playlistName, authToken: authToken!);

      if (response.containsKey('data')) {
        final newPlaylist = response['data'];
        state = [...state, newPlaylist];
      }
    } catch (e) {
      print("Error creating playlist: $e");
    }
  }

  Future<void> addPodcastToPlaylist(String playlistId, String podcastId) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) return;

    final authToken = userState.value!.token;
    try {
      await _apiService.addPodcastToPlaylist(
          playlistId: playlistId, podcastId: podcastId, authToken: authToken!);

      await fetchAllPlaylists();
    } catch (e) {
      print("Error adding podcast to playlist: $e");
    }
  }

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
    }
  }

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

  // ✅ Function to play a podcast in order when started from a playlist
  void playPodcast(
      {required String podcastId, Map<String, dynamic>? playlist}) {
    if (playlist != null) {
      _currentPlaylist = playlist;
      _currentPlaylistPodcasts =
          List<Map<String, dynamic>>.from(playlist['podcasts'] ?? []);
      _currentPodcastIndex = _currentPlaylistPodcasts
          .indexWhere((podcast) => podcast['id'].toString() == podcastId);
    } else {
      _currentPlaylist = null;
      _currentPlaylistPodcasts = [];
      _currentPodcastIndex = -1;
    }

    if (_currentPodcastIndex != -1) {
      _startPlayingPodcast();
    }
  }

  void _startPlayingPodcast() {
    if (_currentPodcastIndex < 0 ||
        _currentPodcastIndex >= _currentPlaylistPodcasts.length) {
      print("No podcast to play");
      return;
    }

    final currentPodcast = _currentPlaylistPodcasts[_currentPodcastIndex];
    final podcastId = currentPodcast['id'].toString();
    print("Playing podcast: $podcastId");

    // TODO: Integrate with audio player logic and listen for completion
  }

// Function to play the next podcast in the playlist
  void playNextPodcast() {
    if (_currentPlaylist == null ||
        _currentPodcastIndex >= _currentPlaylistPodcasts.length - 1) {
      print("Reached the end of the playlist.");
      return;
    }

    _currentPodcastIndex++;
    _startPlayingPodcast();
  }

// Function to play the previous podcast
  void playPreviousPodcast() {
    if (_currentPlaylist == null || _currentPodcastIndex <= 0) {
      print("Already at the beginning of the playlist.");
      return;
    }

    _currentPodcastIndex--;
    _startPlayingPodcast();
  }
}

// Define provider
final playlistProvider =
    StateNotifierProvider<PlaylistNotifier, List<Map<String, dynamic>>>((ref) {
  return PlaylistNotifier(ref);
});
