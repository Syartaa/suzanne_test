// Import necessary packages
import 'package:dio/dio.dart'; // Dio is the HTTP client to make network requests
import 'package:suzanne_podcast_app/models/events.dart'; // Model for events
import 'package:suzanne_podcast_app/models/schedule.dart'; // Model for schedules
import 'package:suzanne_podcast_app/models/user.dart'; // Model for user

class ApiService {
  // Dio client setup with base URL and timeout settings
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://suzanne-podcast.laratest-app.com/api', // Base API URL
      connectTimeout: const Duration(milliseconds: 5000), // Connection timeout
      receiveTimeout: const Duration(milliseconds: 3000), // Receive timeout
    ),
  );

  // Signup user by sending a POST request with user data
  Future<User> registerUser(User user) async {
    try {
      final response = await _dio.post(
        '/register', // Endpoint for registration
        data: user.toJson(), // Convert user object to JSON
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Set content type to JSON
          },
        ),
      );
      return User.fromJson(response.data); // Parse response into User object
    } catch (e) {
      if (e is DioException) {
        // Handle Dio errors
        print("Dio error response: ${e.response?.data}");
      }
      throw Exception("Failed to register user: $e");
    }
  }

  // Login user with email and password
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      return response.data; // Return response data from login
    } catch (e) {
      throw Exception("Failed to login: $e");
    }
  }

  // Fetch a list of podcasts
  Future<List<dynamic>> fetchPodcasts() async {
    try {
      final response = await _dio.get('/podcasts'); // Fetch podcasts from API

      if (response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        return List<dynamic>.from(response.data['data']); // Parse podcast list
      } else {
        throw Exception('Invalid data format');
      }
    } catch (e) {
      throw Exception("Failed to fetch podcasts: $e");
    }
  }

  // Get podcast details by its ID
  Future<Map<String, dynamic>> getPodcastDetail(String id) async {
    try {
      final response = await _dio.get('/podcasts/$id'); // Fetch podcast by ID

      if (response.data is Map<String, dynamic> &&
          response.data['data'] is Map<String, dynamic>) {
        return response.data['data']; // Return podcast details
      } else {
        throw Exception('Invalid data format');
      }
    } catch (e) {
      throw Exception("Failed to fetch podcast detail: $e");
    }
  }

  // Fetch a list of events from API
  Future<List<Event>> fetchEvents() async {
    try {
      final response = await _dio.get('/events'); // Fetch events from API

      if (response.data is Map<String, dynamic> &&
          response.data['data'] is List<dynamic>) {
        return (response.data['data'] as List<dynamic>)
            .map((eventJson) => Event.fromJson(eventJson)) // Parse events
            .toList();
      } else if (response.data is List<dynamic>) {
        return (response.data as List<dynamic>)
            .map((eventJson) => Event.fromJson(eventJson)) // Parse events
            .toList();
      } else {
        throw Exception(
            "Unexpected response type: ${response.data.runtimeType}");
      }
    } catch (e) {
      throw Exception("Failed to fetch events: $e");
    }
  }

  // Get event details by its ID
  Future<Event> getEventDetail(String id) async {
    try {
      final response = await _dio.get('/events/$id'); // Fetch event by ID

      if (response.data is Map<String, dynamic> &&
          response.data['data'] is Map<String, dynamic>) {
        return Event.fromJson(response.data['data']); // Return event detail
      } else if (response.data is Map<String, dynamic>) {
        return Event.fromJson(response.data); // Return event detail directly
      } else {
        throw Exception(
            "Unexpected response type: ${response.data.runtimeType}");
      }
    } catch (e) {
      throw Exception("Failed to fetch event detail: $e");
    }
  }

  // Fetch a list of schedules
  Future<List<Schedule>> fetchSchedules() async {
    try {
      final response = await _dio.get('/schedules'); // Fetch schedules

      if (response.data is List) {
        return (response.data as List)
            .map((scheduleJson) =>
                Schedule.fromJson(scheduleJson)) // Parse schedules
            .toList();
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      throw Exception("Failed to fetch schedules: $e");
    }
  }

  // Fetch schedule by its ID
  Future<Schedule> fetchScheduleById(String id) async {
    try {
      final response = await _dio.get('/schedules/$id'); // Fetch schedule by ID

      if (response.data is Map<String, dynamic>) {
        return Schedule.fromJson(response.data); // Return schedule
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      throw Exception("Failed to fetch schedule by ID: $e");
    }
  }

  // Fetch categories list from the API
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories'); // Fetch categories

      if (response.data is List) {
        return List<Map<String, dynamic>>.from(
            response.data); // Return categories
      } else {
        throw Exception("Unexpected response format for categories");
      }
    } catch (e) {
      throw Exception("Failed to fetch categories: $e");
    }
  }

  // Rate a podcast by its ID
  Future<Map<String, dynamic>> ratePodcast({
    required String podcastId,
    required int rate,
    String? comment,
    required String authToken,
  }) async {
    try {
      final response = await _dio.post(
        '/podcast/$podcastId/rate', // Endpoint for rating
        data: {
          'rate': rate,
          'comment': comment ?? '', // Optional comment
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Set content type to JSON
            'Authorization': 'Bearer $authToken', // Authentication token
          },
        ),
      );

      return response.data; // Return response containing rating data
    } catch (e) {
      if (e is DioException) {
        print("Dio error response: ${e.response?.data}");
      }
      throw Exception("Failed to rate podcast: $e");
    }
  }

  // Get ratings of a podcast by its ID
  Future<Map<String, dynamic>> getPodcastRatings(String podcastId) async {
    try {
      final response =
          await _dio.get('/podcasts/$podcastId/ratings'); // Get ratings

      if (response.data is Map<String, dynamic>) {
        return response.data; // Return ratings data
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

  // Add or remove podcast from favorites
  Future<bool> toggleFavoritePodcast(String podcastId, String authToken) async {
    try {
      if (authToken == null || authToken.isEmpty) {
        print("Token is missing. User needs to log in again.");
        return false;
      }

      final response = await _dio.post(
        '/podcast/$podcastId/favorite', // Toggle favorite
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken', // Use auth token
            'Content-Type': 'application/json', // Set content type to JSON
          },
        ),
      );

      if (response.data != null && response.data['message'] != null) {
        final message = response.data['message'].toString().toLowerCase();
        if (message == "podcast added to favorites.") {
          return true; // Successfully added to favorites
        } else if (message == "podcast removed from favorites.") {
          return false; // Successfully removed from favorites
        }
      }

      print("Unexpected API response format: ${response.data}");
      return false;
    } catch (e) {
      if (e is DioException) {
        print("Dio error response: ${e.response?.data}");
      }
      throw Exception("Failed to toggle favorite podcast: $e");
    }
  }

  // Fetch favorite podcasts of a user
  Future<List<String>> getFavoritePodcasts(String authToken) async {
    try {
      if (authToken == null || authToken.isEmpty) {
        print("Token is missing. User needs to log in again.");
        return [];
      }

      final response = await _dio.get(
        '/user/favorites', // Fetch favorite podcasts
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken', // Use auth token
          },
        ),
      );

      if (response.data != null && response.data['data'] is List) {
        return List<String>.from(response.data['data']
            .map((podcast) => podcast['id'].toString())); // Return podcast IDs
      } else {
        throw Exception("Unexpected response format for favorites");
      }
    } catch (e) {
      throw Exception("Failed to fetch favorite podcasts: $e");
    }
  }

  // Create a new playlist
  Future<Map<String, dynamic>> createPlaylist({
    required String name,
    required String authToken,
  }) async {
    try {
      final response = await _dio.post(
        '/playlists', // Create playlist endpoint
        data: {
          'name': name,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken', // Use auth token
            'Content-Type': 'application/json', // Set content type to JSON
          },
        ),
      );

      return response.data; // Return created playlist data
    } catch (e) {
      throw Exception("Failed to create playlist: $e");
    }
  }

  // Fetch all playlists for a user
  Future<List<Map<String, dynamic>>> getAllPlaylists(String authToken) async {
    try {
      final response = await _dio.get(
        '/playlists', // Get all playlists
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken', // Use auth token
          },
        ),
      );

      if (response.data is Map && response.data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(
            response.data['data']); // Return playlists
      } else {
        throw Exception("Unexpected response format for playlists");
      }
    } catch (e) {
      throw Exception("Failed to fetch playlists: $e");
    }
  }

  // Add a podcast to a playlist
  Future<Map<String, dynamic>> addPodcastToPlaylist({
    required String playlistId,
    required String podcastId,
    required String authToken,
  }) async {
    try {
      final playlistResponse = await _dio.get(
        '/playlists/$playlistId', // Verify playlist existence
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken', // Use auth token
          },
        ),
      );

      // Proceed to add podcast if playlist exists
      final response = await _dio.post(
        '/playlists/$playlistId/podcasts', // Add podcast to playlist
        data: {
          'podcast_id': podcastId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken', // Use auth token
            'Content-Type': 'application/json', // Set content type to JSON
          },
        ),
      );

      return response.data; // Return confirmation data
    } catch (e) {
      throw Exception("Failed to add podcast to playlist: $e");
    }
  }

  // Remove a podcast from a playlist
  Future<Map<String, dynamic>> removePodcastFromPlaylist({
    required String playlistId,
    required String podcastId,
    required String authToken,
  }) async {
    try {
      final response = await _dio.delete(
        '/playlists/$playlistId/podcasts/$podcastId', // Remove podcast
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken', // Use auth token
            'Content-Type': 'application/json', // Set content type to JSON
          },
        ),
      );

      return response.data; // Return confirmation data
    } catch (e) {
      throw Exception("Failed to remove podcast from playlist: $e");
    }
  }

  // Get a specific playlist by ID
  Future<Map<String, dynamic>> getPlaylistById({
    required String playlistId,
    required String authToken,
  }) async {
    try {
      final response = await _dio.get(
        '/playlists/$playlistId', // Fetch playlist by ID
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken', // Use auth token
            'Content-Type': 'application/json', // Set content type to JSON
          },
        ),
      );

      return response.data; // Return playlist data
    } catch (e) {
      throw Exception("Failed to fetch playlist: $e");
    }
  }
}
