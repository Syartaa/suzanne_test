import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzanne_podcast_app/models/user.dart';
import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/provider/favorite_provider.dart';
import 'package:suzanne_podcast_app/provider/playlist_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final ApiService apiService;
  final StateNotifierProviderRef<UserNotifier, AsyncValue<User?>>
      ref; // Add ref

  UserNotifier(this.apiService, this.ref) : super(const AsyncValue.data(null)) {
    _loadUserFromPreferences();
  }

  /// Function to load user data from SharedPreferences
  Future<void> _loadUserFromPreferences() async {
    state = const AsyncValue.loading();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');

      print("Loaded user data from SharedPreferences: $userDataString");

      if (userDataString != null) {
        final userDataJson = jsonDecode(userDataString);
        print("Decoded user data: $userDataJson");

        // Extract the 'user' object from the response
        final userJson = userDataJson['user'];
        if (userJson != null) {
          final user = User.fromJson(userJson);
          state = AsyncValue.data(user);
        } else {
          state = const AsyncValue.data(null);
        }
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (error, stackTrace) {
      print("Error loading user data: $error");
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Function to register a user
  Future<void> registerUser(User user) async {
    state = const AsyncValue.loading();
    try {
      final registeredUser = await apiService.registerUser(user);
      state = AsyncValue.data(registeredUser);
    } catch (error, stackTrace) {
      print("Error during registration: $error");
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Function to log in a user
  Future<void> loginUser(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await apiService.loginUser(email, password);
      print("API Login Response: $response");

      if (response is Map<String, dynamic> && response.containsKey('user')) {
        final loggedInUser = User.fromJson(response['user']);

        // Save only the correct user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'user_data', jsonEncode({'user': response['user']}));

        state = AsyncValue.data(loggedInUser);
        print("User logged in successfully: ${loggedInUser.firstName}");
      } else {
        print("Invalid login response format: $response");
        state = const AsyncValue.data(null);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      print("Error during login: $error");
    }
  }

  /// Function to log out the user and clear all related data
  Future<void> logoutUser() async {
    state = const AsyncValue.loading();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');

      state.whenData((user) {
        if (user != null) {
          final userId = user.id;
          prefs.remove('favorite_podcasts_$userId');
          prefs.remove('user_playlists_$userId');
          print("Cleared favorites and playlists for user $userId.");
        }
      });

      // ✅ Pass the current user explicitly to avoid ref.read issues
      final user = state.value;
      ref.read(playlistProvider.notifier).resetPlaylists(user);
      ref.read(favoriteProvider.notifier).resetFavorites(user);

      state = const AsyncValue.data(null);
      print("User logged out successfully.");
    } catch (error, stackTrace) {
      print("Error during logout: $error");
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return UserNotifier(apiService, ref); // ✅ Pass ref
});
