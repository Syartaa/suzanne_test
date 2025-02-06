import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzanne_podcast_app/models/user.dart';
import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/provider/download_provider.dart';
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

        // Extract the 'user' object and 'token' from the response
        final userJson = userDataJson['user'];
        final token = userDataJson['token'];

        if (userJson != null && token != null) {
          final user = User.fromJson(userJson);
          user.token = token; // Set token to user object
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
    } catch (error) {
      String errorMessage = "Registration failed. Email already exists.";

      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          if (responseData is Map && responseData.containsKey("error")) {
            final errors = responseData["error"];
            if (errors is Map && errors.containsKey("email")) {
              errorMessage = "Email already exists";
            }
          }
        }
      }

      state = AsyncValue.error(errorMessage, StackTrace.current);
    }
  }

  /// Function to log in a user
  Future<String> loginUser(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await apiService.loginUser(email, password);
      print("API Login Response: $response"); // Log the entire response

      if (response.containsKey('user') && response.containsKey('token')) {
        final loggedInUser = User.fromJson(response['user']);
        final token = response['token'];

        loggedInUser.token = token; // ✅ Store token in User object

        // Save both user and token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user_data',
          jsonEncode({'user': response['user'], 'token': token}),
        );

        state = AsyncValue.data(loggedInUser);
        print("User logged in successfully: ${loggedInUser.firstName}");
        return 'Success'; // Login successful
      } else if (response.containsKey('message')) {
        if (response['message'] == 'User not found') {
          return 'User not found'; // User doesn't exist
        } else if (response['message'] == 'Incorrect password') {
          return 'Incorrect password'; // Password incorrect
        } else {
          return 'Invalid login data'; // Unknown error or incorrect response format
        }
      } else {
        return 'Invalid login data'; // Unknown error
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      print("Error during login: $error");
      return 'Error'; // General error
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

          prefs.remove('downloads_$userId'); // ✅ Clear downloaded podcasts

          print("Cleared  downloads for user $userId.");
        }
      });

      // ✅ Pass the current user explicitly to avoid ref.read issues
      final user = state.value;
      ref
          .read(downloadProvider.notifier)
          .resetDownloads(user); // ✅ Reset downloads

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
