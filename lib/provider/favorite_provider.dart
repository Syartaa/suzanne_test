import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';

class FavoriteNotifier extends StateNotifier<List<String>> {
  FavoriteNotifier(this.ref) : super([]) {
    _loadFavorites();
  }

  final Ref ref;

  /// Load favorite podcasts from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favorite_podcasts') ?? [];
    print(
        'Loaded favorites from SharedPreferences: $favoriteList'); // Debugging
    state = favoriteList;
  }

  /// Toggle favorite (add/remove) only if the user is logged in
  Future<void> toggleFavorite(String podcastId) async {
    final userState = ref.read(userProvider);

    if (userState.value == null) {
      print("User not logged in! Cannot favorite.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = state;

    print('Current favorites before toggle: $currentFavorites'); // Debugging

    if (currentFavorites.contains(podcastId)) {
      state = currentFavorites.where((id) => id != podcastId).toList();
      print('Removed podcast $podcastId from favorites');
    } else {
      state = [...currentFavorites, podcastId];
      print('Added podcast $podcastId to favorites');
    }

    await prefs.setStringList('favorite_podcasts', state);
    print('Updated favorites saved to SharedPreferences: $state'); // Debugging
  }

  /// Check if a podcast is favorited
  bool isFavorited(String podcastId) {
    print(
        'Checking if podcast $podcastId is favorited: ${state.contains(podcastId)}'); // Debugging
    return state.contains(podcastId);
  }
}

/// Favorite Provider
final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<String>>((ref) {
  return FavoriteNotifier(ref);
});
