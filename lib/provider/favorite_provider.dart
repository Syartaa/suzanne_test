import 'package:flutter_riverpod/flutter_riverpod.dart'; // For state management with Riverpod
import 'package:suzanne_podcast_app/provider/api_service_provider.dart'; // API service provider
import 'package:suzanne_podcast_app/provider/user_provider.dart'; // User provider for authentication state
import 'package:suzanne_podcast_app/services/api_service.dart'; // API service for fetching data

// The FavoriteNotifier is responsible for managing the user's favorite podcasts.
class FavoriteNotifier extends StateNotifier<List<String>> {
  final Ref ref;
  final ApiService _apiService;

  bool _favoritesLoaded = false; // Flag to check if favorites have been loaded
  bool isLoading = false; // Flag to track loading state

  // Constructor for the FavoriteNotifier
  FavoriteNotifier(this.ref, this._apiService) : super([]) {
    // Listen to the user state to handle login/logout and update favorites accordingly
    ref.listen(userProvider, (previous, next) {
      if (next.isLoading || next.hasError)
        return; // Do nothing if loading or error state

      // If user logs out or has no token, clear the favorites
      if (next.value == null || next.value!.token == null) {
        state = [];
        print("User logged out. Clearing favorite podcasts.");
      }
      // If user logs in with a new token, fetch favorites
      else if (previous?.value?.token != next.value!.token) {
        print("User logged in. Fetching favorites...");
        loadFavorites();
      }
    });

    // If the user is already logged in, fetch their favorite podcasts
    if (ref.read(userProvider).value?.token != null) {
      loadFavorites();
    }
  }

  // Method to load the user's favorite podcasts from the API
  Future<void> loadFavorites() async {
    if (_favoritesLoaded || isLoading)
      return; // Prevent multiple API calls if already loading or favorites are loaded

    final userState = ref.read(userProvider); // Read current user state

    // If the user is not logged in, skip the favorite fetch
    if (userState.value == null || userState.value!.token == null) {
      print("User not logged in, skipping favorite fetch.");
      state = []; // Clear favorites if user is not logged in
      return;
    }

    final authToken = userState.value!.token!; // Get the authentication token

    // Set loading state to true and clear previous favorites while fetching
    isLoading = true;
    state = [];

    try {
      // Fetch favorites from API
      final favorites = await _apiService.getFavoritePodcasts(authToken);
      state = favorites; // Update state with the fetched favorites
      _favoritesLoaded = true; // Mark favorites as loaded
      print("Favorites loaded successfully: $favorites");
    } catch (e) {
      print("Error loading favorites: $e");
      state = []; // Clear state in case of an error
    } finally {
      isLoading =
          false; // Set loading state to false after the fetch is complete
    }
  }

  // Method to toggle a podcast as favorite or not favorite
  Future<void> toggleFavorite(String podcastId) async {
    final userState = ref.read(userProvider); // Read current user state

    // If user is not logged in, print an error and return
    if (userState.value == null || userState.value!.token == null) {
      print("User not logged in or token is null! Cannot favorite.");
      return;
    }

    final authToken = userState.value!.token!; // Get the authentication token

    // Check if the podcast is already in the favorites list
    final isCurrentlyFavorited = state.contains(podcastId);
    // Update the favorites list by either adding or removing the podcast
    final updatedFavorites = isCurrentlyFavorited
        ? state.where((id) => id != podcastId).toList() // Remove from favorites
        : [...state, podcastId]; // Add to favorites

    state = updatedFavorites; // Update state with the new favorites list

    try {
      // Toggle the favorite status of the podcast via API
      final success =
          await _apiService.toggleFavoritePodcast(podcastId, authToken);

      // If the API call fails, revert the change in the state
      if (!success) {
        print("API failed to toggle favorite for podcast $podcastId.");
        state = isCurrentlyFavorited
            ? [...state, podcastId] // Restore state to previous state if failed
            : state.where((id) => id != podcastId).toList();
      }
    } catch (e) {
      print("Error toggling favorite: $e");
      // If an error occurs, revert the favorite status change in the state
      state = isCurrentlyFavorited
          ? [...state, podcastId]
          : state.where((id) => id != podcastId).toList();
    }
  }

  // Method to check if a podcast is favorited
  bool isFavorited(String podcastId) {
    return state.contains(
        podcastId); // Return true if the podcast is in the favorites list
  }
}

// Riverpod StateNotifierProvider for managing the favorite podcasts state
final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<String>>((ref) {
  return FavoriteNotifier(
      ref,
      ref.watch(
          apiServiceProvider)); // Provide the FavoriteNotifier with dependencies
});
