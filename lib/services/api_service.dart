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
}
