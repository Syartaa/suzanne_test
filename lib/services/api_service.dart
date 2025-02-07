import 'package:dio/dio.dart';
import 'package:suzanne_podcast_app/models/events.dart';
import 'package:suzanne_podcast_app/models/schedule.dart';
import 'package:suzanne_podcast_app/models/user.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://suzanne-podcast.laratest-app.com/api',
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
    ),
  );

  Future<User> registerUser(User user) async {
    try {
      final response = await _dio.post(
        '/register',
        data: user.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return User.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        // Log the response data for better error handling
        print("Dio error response: ${e.response?.data}");
      }
      throw Exception("Failed to register user: $e");
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw Exception("Failed to login: $e");
    }
  }

  Future<List<dynamic>> fetchPodcasts() async {
    try {
      final response = await _dio.get('/podcasts');
      return response.data; // Assuming the response is a list of podcasts
    } catch (e) {
      throw Exception("Failed to fetch podcasts: $e");
    }
  }

  Future<Map<String, dynamic>> getPodcastDetail(String id) async {
    try {
      final response = await _dio.get('/podcasts/$id');
      return response.data;
    } catch (e) {
      throw Exception("Failed to fetch podcast detail: $e");
    }
  }

  Future<List<Event>> fetchEvents() async {
    try {
      final response = await _dio.get('/events');

      // Assuming the response data is in { "data": [...] }
      if (response.data is Map<String, dynamic> &&
          response.data['data'] is List<dynamic>) {
        return (response.data['data'] as List<dynamic>)
            .map((eventJson) => Event.fromJson(eventJson))
            .toList();
      } else if (response.data is List<dynamic>) {
        // Handle the case where it's a direct list
        return (response.data as List<dynamic>)
            .map((eventJson) => Event.fromJson(eventJson))
            .toList();
      } else {
        throw Exception(
            "Unexpected response type: ${response.data.runtimeType}");
      }
    } catch (e) {
      throw Exception("Failed to fetch events: $e");
    }
  }

  Future<Event> getEventDetail(String id) async {
    try {
      final response = await _dio.get('/events/$id');

      // Assuming the response data is in { "data": { ... } }
      if (response.data is Map<String, dynamic> &&
          response.data['data'] is Map<String, dynamic>) {
        return Event.fromJson(response.data['data']);
      } else if (response.data is Map<String, dynamic>) {
        // Handle direct event object
        return Event.fromJson(response.data);
      } else {
        throw Exception(
            "Unexpected response type: ${response.data.runtimeType}");
      }
    } catch (e) {
      throw Exception("Failed to fetch event detail: $e");
    }
  }

  Future<List<Schedule>> fetchSchedules() async {
    try {
      final response = await _dio.get('/schedules');
      if (response.data is List) {
        return (response.data as List)
            .map((scheduleJson) => Schedule.fromJson(scheduleJson))
            .toList();
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      throw Exception("Failed to fetch schedules: $e");
    }
  }

  Future<Schedule> fetchScheduleById(String id) async {
    try {
      final response = await _dio.get('/schedules/$id');
      if (response.data is Map<String, dynamic>) {
        return Schedule.fromJson(
            response.data); // Assuming Schedule has a fromJson method
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      throw Exception("Failed to fetch schedule by ID: $e");
    }
  }

  // New method to fetch categories
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories');
      // Assuming the response data is a list of maps
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(
            response.data); // Correctly map the data
      } else {
        throw Exception("Unexpected response format for categories");
      }
    } catch (e) {
      throw Exception("Failed to fetch categories: $e");
    }
  }

//post rate
  Future<Map<String, dynamic>> ratePodcast({
    required String podcastId,
    required int rate,
    String? comment,
    required String authToken, // Assuming authentication is required
  }) async {
    try {
      final response = await _dio.post(
        '/podcast/$podcastId/rate',
        data: {
          'rate': rate,
          'comment': comment ?? '', // Optional comment
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken', // Include the token
          },
        ),
      );

      return response.data; // Assuming the response follows the given structure
    } catch (e) {
      if (e is DioException) {
        print("Dio error response: ${e.response?.data}");
      }
      throw Exception("Failed to rate podcast: $e");
    }
  }

//get ratings
  Future<Map<String, dynamic>> getPodcastRatings(String podcastId) async {
    try {
      final response = await _dio.get('/podcasts/$podcastId/ratings');

      if (response.data is Map<String, dynamic>) {
        return response.data; // Returns the full response (ratings + message)
      } else {
        throw Exception(
            "Unexpected response format: ${response.data.runtimeType}");
      }
    } catch (e) {
      if (e is DioException) {
        print("Dio error response: ${e.response?.data}");
      }
      throw Exception("Failed to fetch podcast ratings: $e");
    }
  }

  // Add/Remove Podcast from Favorites
  Future<bool> toggleFavoritePodcast(String podcastId, String authToken) async {
    try {
      if (authToken == null || authToken.isEmpty) {
        print("Token is missing. User needs to log in again.");
        // Prompt user to log in
        return false;
      }

      final response = await _dio.post(
        '/podcast/$podcastId/favorite',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("API response data: ${response.data}");

      if (response.data != null && response.data['message'] != null) {
        final message = response.data['message'].toString().toLowerCase();
        if (message == "podcast added to favorites.") {
          return true; // Favorited successfully
        } else if (message == "podcast removed from favorites.") {
          return false; // Unfavorited successfully
        }
      }

      print("Unexpected API response format: ${response.data}");
      return false;
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 302) {
          print("Redirecting to login, token might be expired or invalid.");
          // Handle token expiration or invalid token by prompting the user to log in
        }
        print("Dio error response: ${e.response?.data}");
      }
      print("Error toggling favorite podcast: $e");
      throw Exception("Failed to toggle favorite podcast: $e");
    }
  }

  Future<List<String>> getFavoritePodcasts(String authToken) async {
    try {
      if (authToken == null || authToken.isEmpty) {
        print("Token is missing. User needs to log in again.");
        return [];
      }

      final response = await _dio.get(
        '/user/favorites',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      // Check if response has 'data' and it is a list
      if (response.data != null && response.data['data'] is List) {
        // Extract podcast IDs as strings from the 'data' list
        return List<String>.from(
            response.data['data'].map((podcast) => podcast['id'].toString()));
      } else {
        throw Exception("Unexpected response format for favorites");
      }
    } catch (e) {
      if (e is DioException) {
        print("Dio error response: ${e.response?.data}");
      }
      print("Error fetching favorite podcasts: $e");
      throw Exception("Failed to fetch favorite podcasts: $e");
    }
  }

  ///playlist API
  ///playlist create
  Future<Map<String, dynamic>> createPlaylist({
    required String name,
    required String authToken,
  }) async {
    try {
      final response = await _dio.post(
        '/playlists',
        data: {
          'name': name,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("Playlist Created: ${response.data}"); // Debugging

      return response
          .data; // Assuming response contains the created playlist data
    } catch (e) {
      if (e is DioException) {
        print("Dio error response: ${e.response?.data}");
      }
      throw Exception("Failed to create playlist: $e");
    }
  }

//Get All Playlists
  Future<List<Map<String, dynamic>>> getAllPlaylists(String authToken) async {
    try {
      final response = await _dio.get(
        '/playlists',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      print("Fetched Playlists: ${response.data}"); // Debugging

      if (response.data is Map && response.data.containsKey('error')) {
        throw Exception("API Error: ${response.data['error']}");
      }

      if (response.data is Map && response.data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception("Unexpected response format for playlists");
      }
    } catch (e) {
      print("Dio error response: ${e is DioException ? e.response?.data : e}");
      throw Exception("Failed to fetch playlists: $e");
    }
  }

  ///podcast to a playlist
  Future<Map<String, dynamic>> addPodcastToPlaylist({
    required String playlistId,
    required String podcastId,
    required String authToken,
  }) async {
    try {
      // Fetch the playlist first to confirm it exists
      final playlistResponse = await _dio.get(
        '/playlists/$playlistId',
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      if (playlistResponse.data is Map &&
          playlistResponse.data.containsKey('error')) {
        throw Exception(
            "Playlist not found: ${playlistResponse.data['error']}");
      }

      // Now add podcast to playlist
      final response = await _dio.post(
        '/playlists/$playlistId/podcasts',
        data: {
          'podcast_id': podcastId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("Podcast added to playlist: ${response.data}"); // Debugging

      return response.data;
    } catch (e) {
      if (e is DioException) {
        print("Dio error response: ${e.response?.data}");
      }
      throw Exception("Failed to add podcast to playlist: $e");
    }
  }

//remove a podcast from playlist
  Future<Map<String, dynamic>> removePodcastFromPlaylist({
    required String playlistId,
    required String podcastId,
    required String authToken,
  }) async {
    try {
      final response = await _dio.delete(
        '/playlists/$playlistId/podcasts/$podcastId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("Podcast removed from playlist: ${response.data}"); // Debugging

      return response.data; // Response contains message confirming removal
    } catch (e) {
      if (e is DioException) {
        print("Dio error response: ${e.response?.data}");
      }
      throw Exception("Failed to remove podcast from playlist: $e");
    }
  }

// get playlist id
  Future<Map<String, dynamic>> getPlaylistById({
    required String playlistId,
    required String authToken,
  }) async {
    try {
      final response = await _dio.get(
        '/playlists/$playlistId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("Fetched playlist data: ${response.data}"); // Debugging

      return response.data; // Returns the playlist data including podcasts
    } catch (e) {
      if (e is DioException) {
        print("Dio error response: ${e.response?.data}");
      }
      throw Exception("Failed to fetch playlist: $e");
    }
  }
}
