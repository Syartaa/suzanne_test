import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/models/schedule.dart';
import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SchedulesNotifier extends StateNotifier<AsyncValue<List<Schedule>>> {
  SchedulesNotifier(this.apiService) : super(const AsyncValue.loading());

  final ApiService apiService;

  Future<void> loadSchedules() async {
    if (state is AsyncData<List<Schedule>> &&
        (state as AsyncData<List<Schedule>>).value.isNotEmpty) {
      print("Schedules already loaded, skipping fetch.");
      return; // Skip fetching if data is already loaded
    }
    // Check for internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No internet, fetch schedules from cache
      await _loadSchedulesFromCache();
    } else {
      // Fetch from API if online
      await _loadSchedulesFromApi();
    }
  }

  Future<void> _loadSchedulesFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedSchedulesJson = prefs.getString('schedules');
    if (cachedSchedulesJson != null) {
      List<dynamic> cachedSchedules = jsonDecode(cachedSchedulesJson);
      state = AsyncValue.data(
        cachedSchedules
            .map((item) => Schedule.fromJson(item))
            .toList()
            .reversed
            .toList(),
      ); // Reverse the cached data as well
    } else {
      state = const AsyncValue.loading();
    }
  }

  Future<void> _loadSchedulesFromApi() async {
    try {
      state = const AsyncValue.loading(); // Set loading state
      print("Fetching schedules..."); // Debug log
      final schedules = await apiService.fetchSchedules();

      // Reverse the list so the newest schedules appear first
      state = AsyncValue.data(schedules.reversed.toList());

      // Cache the schedules in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String schedulesJson = jsonEncode(schedules);
      await prefs.setString('schedules', schedulesJson);
    } catch (e, stackTrace) {
      print("Error fetching schedules: $e"); // Debug log
    }
  }

  Future<void> loadScheduleById(String id) async {
    try {
      state = const AsyncValue.loading(); // Set loading state
      print("Fetching schedule by ID: $id"); // Debug log
      final schedule = await apiService.fetchScheduleById(id);
      state = AsyncValue.data([schedule]); // Update with fetched schedule
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Handle errors
    }
  }
}

// StateNotifierProvider for SchedulesNotifier
final schedulesNotifierProvider =
    StateNotifierProvider<SchedulesNotifier, AsyncValue<List<Schedule>>>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    return SchedulesNotifier(apiService);
  },
);
