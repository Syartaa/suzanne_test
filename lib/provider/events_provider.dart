import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/models/events.dart';
import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class EventNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  EventNotifier(this.apiService) : super(const AsyncValue.loading());

  final ApiService apiService;

  Future<void> loadEvents() async {
    try {
      state = const AsyncValue.loading(); // Set the loading state
      final events = await apiService.fetchEvents();
      state = AsyncValue.data(events); // Update with fetched data
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Handle errors gracefully
    }
  }
}

final EventProvider = FutureProvider<List<Event>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchEvents(); // Fetch and return events
});
