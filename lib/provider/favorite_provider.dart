import 'package:flutter_riverpod/flutter_riverpod.dart'; // For state management with Riverpod
import 'package:suzanne_podcast_app/provider/api_service_provider.dart'; // API service provider
import 'package:suzanne_podcast_app/provider/user_provider.dart'; // User provider for authentication state
import 'package:suzanne_podcast_app/services/api_service.dart'; // API service for fetching data

// The FavoriteNotifier is responsible for managing the user's favorite podcasts.
class FavoriteNotifier extends StateNotifier<List<String>> {
  final Ref ref;
  final ApiService _apiService;

  bool _favoritesLoaded = false;
  bool isLoading = false;

  FavoriteNotifier(this.ref, this._apiService) : super([]) {
    ref.listen(userProvider, (previous, next) {
      if (next.isLoading || next.hasError) return;

      if (next.value == null || next.value!.token == null) {
        state = []; // Clear favorites if the user logs out
        print("User logged out. Clearing favorite podcasts.");
      } else if (previous?.value?.token != next.value!.token) {
        print("User logged in. Fetching favorites...");
        loadFavorites();
      }
    });

    // Load favorites if the user is already logged in
    if (ref.read(userProvider).value?.token != null) {
      loadFavorites();
    }
  }

  // Load favorites from the API
  Future<void> loadFavorites() async {
    if (isLoading) return;

    final userState = ref.read(userProvider);
    if (userState.value == null || userState.value!.token == null) {
      print("User not logged in, skipping favorite fetch.");
      state = [];
      return;
    }

    final authToken = userState.value!.token!;
    isLoading = true;

    try {
      final favorites = await _apiService.getFavoritePodcasts(authToken);
      state = favorites;
      _favoritesLoaded = true; // Only mark as loaded if successful
      print("Favorites loaded successfully: $favorites");
    } catch (e) {
      print("Error loading favorites: $e");
      _favoritesLoaded = false; // Allow re-fetching if it failed
      state = [];
    } finally {
      isLoading = false;
    }
  }

  // Toggle favorite status with improved state management
  Future<void> toggleFavorite(String podcastId) async {
    final userState = ref.read(userProvider);

    if (userState.value == null || userState.value!.token == null) {
      print("User not logged in or token is null! Cannot favorite.");
      return;
    }

    final authToken = userState.value!.token!.trim();
    if (authToken.isEmpty) {
      print("Invalid token detected.");
      return;
    }

    final isCurrentlyFavorited = state.contains(podcastId);

    if (isLoading) {
      print("Already loading, please wait.");
      return;
    }

    isLoading = true;
    try {
      final success =
          await _apiService.toggleFavoritePodcast(podcastId, authToken);

      if (success) {
        state = isCurrentlyFavorited
            ? state.where((id) => id != podcastId).toList()
            : [...state, podcastId];
      } else {
        print("API failed to toggle favorite for podcast $podcastId.");
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    } finally {
      isLoading = false;
    }
  }

  bool isFavorited(String podcastId) {
    return state.contains(podcastId);
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
