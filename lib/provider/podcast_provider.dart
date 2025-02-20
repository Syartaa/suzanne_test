import 'dart:convert'; // For encoding/decoding JSON data
import 'package:flutter_riverpod/flutter_riverpod.dart'; // For managing state with Riverpod
import 'package:suzanne_podcast_app/provider/api_service_provider.dart'; // API service provider
import 'package:suzanne_podcast_app/services/api_service.dart'; // API service class
import 'package:shared_preferences/shared_preferences.dart'; // For caching data locally
import 'package:connectivity_plus/connectivity_plus.dart'; // For checking network connectivity

// The PodcastNotifier handles loading podcasts from either cache or API.
class PodcastNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  // Constructor initializes the API service and sets the state to loading initially
  PodcastNotifier(this.apiService) : super(const AsyncValue.loading());

  final ApiService apiService;

  // This method decides whether to load podcasts from cache or API based on connectivity.
  Future<void> loadPodcasts() async {
    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // If there's no internet, load podcasts from cache
      await _loadPodcastsFromCache();
    } else {
      // If online, fetch podcasts from API
      await _loadPodcastsFromApi();
    }
  }

  // This method fetches podcasts from SharedPreferences (cache).
  Future<void> _loadPodcastsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedPodcastsJson =
        prefs.getString('podcasts'); // Fetch cached podcasts

    if (cachedPodcastsJson != null) {
      // If podcasts are cached, load them and set the state to 'data'
      List<dynamic> cachedPodcasts = jsonDecode(cachedPodcastsJson);
      state = AsyncValue.data(cachedPodcasts); // Set state to loaded podcasts
    } else {
      // If there's no cached data, leave the state in loading mode
      state = const AsyncValue.loading();
    }
  }

  // This method fetches podcasts from the API and caches them.
  Future<void> _loadPodcastsFromApi() async {
    try {
      state = const AsyncValue
          .loading(); // Set state to loading before fetching from the API
      final response =
          await apiService.fetchPodcasts(); // Fetch podcasts from API
      state = AsyncValue.data(response); // Update state with fetched data

      // Cache the podcasts for offline usage
      final prefs = await SharedPreferences.getInstance();
      String podcastsJson = jsonEncode(response); // Encode podcasts to JSON
      await prefs.setString(
          'podcasts', podcastsJson); // Save them in SharedPreferences
    } catch (e, stackTrace) {
      // If an error occurs while fetching from the API, set the state to error
      print("Error loading podcasts data: $e"); // Print error for debugging
      state = AsyncValue.error(
          e, stackTrace); // Set state to error with the exception
    }
  }
}

// Riverpod StateNotifierProvider that provides an instance of PodcastNotifier
// This automatically calls `loadPodcasts()` when the provider is created.
final podcastProvider =
    StateNotifierProvider<PodcastNotifier, AsyncValue<List<dynamic>>>((ref) {
  final apiService =
      ref.read(apiServiceProvider); // Get the ApiService from the provider
  return PodcastNotifier(apiService)
    ..loadPodcasts(); // Initialize the notifier and load podcasts
});
