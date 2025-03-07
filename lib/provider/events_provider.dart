import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/models/events.dart';
import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class EventNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final ApiService apiService;

  EventNotifier(this.apiService) : super(const AsyncValue.loading()) {
    _loadEvents();
  }

  // Local cache to store fetched events
  List<Event>? _cachedEvents;

  // Try to load events faster, with caching mechanism
  Future<void> _loadEvents({bool forceRefresh = true}) async {
    if (!forceRefresh && _cachedEvents != null) {
      state = AsyncValue.data(_cachedEvents!);
      return;
    }

    try {
      final events = await apiService.fetchEvents();
      _cachedEvents = events; // Cache the fetched events
      state = AsyncValue.data(events);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Add refresh function
  Future<void> refreshEvents() async {
    state = const AsyncValue.loading(); // Force loading state
    await _loadEvents(forceRefresh: true);
  }

  // Fetch events based on a schedule ID
  Future<void> loadEventsByScheduleId(int scheduleId) async {
    try {
      // Fetch events from API if cache is null
      if (_cachedEvents == null) {
        _cachedEvents = await apiService.fetchEvents();
      }

      // Filter events based on scheduleId
      final filteredEvents = _cachedEvents!
          .where((event) => event.scheduleId == scheduleId)
          .toList();

      state = AsyncValue.data(filteredEvents);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// ** Provider for managing event state **
final eventNotifierProvider =
    StateNotifierProvider<EventNotifier, AsyncValue<List<Event>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return EventNotifier(apiService);
});

// ** Provider to pre-fetch events in the background **
final preFetchedEventsProvider = Provider.autoDispose<Future<void>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService
      .fetchEvents(); // Pre-fetch events in the background when possible
});
