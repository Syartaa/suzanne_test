import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/models/schedule.dart';
import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class SchedulesNotifier extends StateNotifier<AsyncValue<List<Schedule>>> {
  SchedulesNotifier(this.apiService) : super(const AsyncValue.loading());

  final ApiService apiService;

  Future<void> loadSchedules() async {
    try {
      state = const AsyncValue.loading(); // Set the loading state
      print("Fetching schedules..."); // Debug log
      final schedules = await apiService.fetchSchedules();
      state = AsyncValue.data(schedules); // Update with fetched data
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Handle errors gracefully
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
