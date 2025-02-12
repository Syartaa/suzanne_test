import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class FavoriteNotifier extends StateNotifier<List<String>> {
  final Ref ref;
  final ApiService _apiService;

  bool _favoritesLoaded = false;
  bool isLoading = false; // Add loading flag

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

    if (ref.read(userProvider).value?.token != null) {
      loadFavorites();
    }
  }

  Future<void> loadFavorites() async {
    if (_favoritesLoaded || isLoading) return; // Prevent multiple API calls

    final userState = ref.read(userProvider);

    if (userState.value == null || userState.value!.token == null) {
      print("User not logged in, skipping favorite fetch.");
      state = [];
      return;
    }

    final authToken = userState.value!.token!;

    // Set loading state to true
    isLoading = true;
    state = []; // Clear favorites while loading

    try {
      final favorites = await _apiService.getFavoritePodcasts(authToken);
      state = favorites;
      _favoritesLoaded = true;
      print("Favorites loaded successfully: $favorites");
    } catch (e) {
      print("Error loading favorites: $e");
      state = [];
    } finally {
      isLoading = false; // Set loading state to false after loading is complete
    }
  }

  Future<void> toggleFavorite(String podcastId) async {
    final userState = ref.read(userProvider);

    if (userState.value == null || userState.value!.token == null) {
      print("User not logged in or token is null! Cannot favorite.");
      return;
    }

    final authToken = userState.value!.token!;

    final isCurrentlyFavorited = state.contains(podcastId);
    final updatedFavorites = isCurrentlyFavorited
        ? state.where((id) => id != podcastId).toList()
        : [...state, podcastId];

    state = updatedFavorites;

    try {
      final success =
          await _apiService.toggleFavoritePodcast(podcastId, authToken);

      if (!success) {
        print("API failed to toggle favorite for podcast $podcastId.");
        state = isCurrentlyFavorited
            ? [...state, podcastId]
            : state.where((id) => id != podcastId).toList();
      }
    } catch (e) {
      print("Error toggling favorite: $e");
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
