import 'package:dio/dio.dart';
import 'package:suzanne_podcast_app/models/events.dart';
import 'package:suzanne_podcast_app/models/schedule.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://suzanne-podcast.laratest-app.com/api',
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
    ),
  );

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
}
