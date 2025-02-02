import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PodcastNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  PodcastNotifier(this.apiService) : super(const AsyncValue.loading());

  final ApiService apiService;

  Future<void> loadPodcasts() async {
    // Check for internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No internet, fetch podcasts from cache
      await _loadPodcastsFromCache();
    } else {
      // Fetch from API if online
      await _loadPodcastsFromApi();
    }
  }

  Future<void> _loadPodcastsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedPodcastsJson = prefs.getString('podcasts');
    if (cachedPodcastsJson != null) {
      List<dynamic> cachedPodcasts = jsonDecode(cachedPodcastsJson);
      state = AsyncValue.data(cachedPodcasts); // Load cached data
    } else {
      // If no cached data is available, just leave the state as loading
      state = const AsyncValue.loading();
    }
  }

  Future<void> _loadPodcastsFromApi() async {
    try {
      state = const AsyncValue.loading(); // Set loading state
      final response = await apiService.fetchPodcasts();
      state = AsyncValue.data(response); // Update with fetched data

      // Cache the podcasts in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String podcastsJson = jsonEncode(response);
      await prefs.setString('podcasts', podcastsJson);
    } catch (e, stackTrace) {
      // If there's an error fetching from the API, don't update with an error,
      // just keep the state as it was (or load cached data if available)
      // You can add a log here if you need to debug
    }
  }
}

final podcastProvider =
    StateNotifierProvider<PodcastNotifier, AsyncValue<List<dynamic>>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return PodcastNotifier(apiService)..loadPodcasts();
});
