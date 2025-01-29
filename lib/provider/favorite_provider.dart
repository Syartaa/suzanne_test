import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzanne_podcast_app/models/user.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';

class FavoriteNotifier extends StateNotifier<List<String>> {
  FavoriteNotifier(this.ref) : super([]) {
    loadFavorites();
  }

  final Ref ref;

  /// Load favorite podcasts from SharedPreferences based on user ID
  Future<void> loadFavorites() async {
    final userState = ref.read(userProvider); // Use read instead of watch
    final prefs = await SharedPreferences.getInstance();

    if (userState.value != null) {
      // Ensure user data is available
      final userId = userState.value!.id;
      final favoritesJson = prefs.getString('favorite_podcasts_$userId');

      if (favoritesJson != null) {
        state = List<String>.from(json.decode(favoritesJson));
        print("Loaded favorites for user $userId: $state");
      } else {
        print("No favorites found for user $userId.");
      }
    } else {
      print("User not loaded yet or is null.");
      state = [];
    }
  }

  /// Toggle favorite (add/remove) based on the logged-in user
  Future<void> toggleFavorite(String podcastId) async {
    final userState = ref.read(userProvider);

    if (userState.value == null) {
      print("User not logged in! Cannot favorite.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = userState.value!.id;
    final currentFavorites = state;

    if (currentFavorites.contains(podcastId)) {
      state = currentFavorites.where((id) => id != podcastId).toList();
      print('Removed podcast $podcastId from favorites');
    } else {
      state = [...currentFavorites, podcastId];
      print('Added podcast $podcastId to favorites');
    }

    await prefs.setStringList('favorite_podcasts_$userId', state);
    print('Updated favorites saved for user $userId: $state');
  }

  /// Reset favorites when the user logs out
  Future<void> resetFavorites(User? user) async {
    state = []; // Clear in-memory state
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      final userId = user.id;
      await prefs
          .remove('favorite_podcasts_$userId'); // Remove from SharedPreferences
      print("Reset favorites for user $userId");
    }
  }

  /// Check if a podcast is favorited
  bool isFavorited(String podcastId) {
    return state.contains(podcastId);
  }
}

/// Favorite Provider
final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<String>>((ref) {
  return FavoriteNotifier(ref);
});
