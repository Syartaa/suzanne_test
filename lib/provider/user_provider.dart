import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzanne_podcast_app/models/user.dart';
import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final ApiService apiService;

  UserNotifier(this.apiService) : super(const AsyncValue.data(null)) {
    _loadUserFromPreferences(); // Load user data on initialization
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
      final loggedInUser = User.fromJson(response);

      // Save user data to SharedPreferences for persistence
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(response));

      state = AsyncValue.data(loggedInUser);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Function to log out the user
  Future<void> logoutUser() async {
    state = const AsyncValue.loading();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data'); // Remove user data

      state = const AsyncValue.data(null); // Reset the state to null
    } catch (error, stackTrace) {
      print("Error during logout: $error");
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return UserNotifier(apiService);
});
