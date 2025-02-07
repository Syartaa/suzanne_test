import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class FavoriteNotifier extends StateNotifier<List<String>> {
  final Ref ref;
  final ApiService _apiService;

  // Flag to track if favorites have already been loaded
  bool _favoritesLoaded = false;

  FavoriteNotifier(this.ref, this._apiService) : super([]) {
    ref.listen(userProvider, (previous, next) {
      if (next.isLoading || next.hasError) return;

      if (next.value == null || next.value!.token == null) {
        state = [];
        print("User logged out. Clearing favorite podcasts.");
      } else if (previous?.value?.token != next.value!.token) {
        print("User logged in. Fetching favorites...");
        loadFavorites();
      }
    });

    // Ensure that we load favorites immediately when the app starts and user is logged in
    if (ref.read(userProvider).value?.token != null) {
      loadFavorites();
    }
  }

  Future<void> loadFavorites() async {
    if (_favoritesLoaded) return; // Prevent multiple API calls

    final userState = ref.read(userProvider);

    if (userState.value == null || userState.value!.token == null) {
      print("User not logged in, skipping favorite fetch.");
      state = [];
      return;
    }

    final authToken = userState.value!.token!;

    try {
      final favorites = await _apiService.getFavoritePodcasts(authToken);
      state = favorites;
      _favoritesLoaded = true; // Mark favorites as loaded
      print("Favorites loaded successfully: $favorites");
    } catch (e) {
      print("Error loading favorites: $e");
      state = [];
    }
  }

  Future<void> toggleFavorite(String podcastId) async {
    final userState = ref.read(userProvider);

    if (userState.value == null || userState.value!.token == null) {
      print("User not logged in or token is null! Cannot favorite.");
      return;
    }

    final authToken = userState.value!.token!;

    // Optimistically update the UI immediately
    final isCurrentlyFavorited = state.contains(podcastId);
    final updatedFavorites = isCurrentlyFavorited
        ? state.where((id) => id != podcastId).toList() // Remove from favorites
        : [...state, podcastId]; // Add to favorites

    state = updatedFavorites; // Immediately update UI

    try {
      final success =
          await _apiService.toggleFavoritePodcast(podcastId, authToken);

      if (!success) {
        print("API failed to toggle favorite for podcast $podcastId.");
        // Revert state if API call fails
        state = isCurrentlyFavorited
            ? [...state, podcastId]
            : state.where((id) => id != podcastId).toList();
      }
    } catch (e) {
      print("Error toggling favorite: $e");
      // Revert state on error
      state = isCurrentlyFavorited
          ? [...state, podcastId]
          : state.where((id) => id != podcastId).toList();
    }
  }

  bool isFavorited(String podcastId) {
    return state.contains(podcastId);
  }
}

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<String>>((ref) {
  return FavoriteNotifier(ref, ref.watch(apiServiceProvider));
});
