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
  Future<void> _loadEvents() async {
    if (_cachedEvents != null) {
      // If events are cached, load them directly
      state = AsyncValue.data(_cachedEvents!);
    } else {
      try {
        // Fetch from API if no cached data
        final events = await apiService.fetchEvents();
        _cachedEvents = events; // Cache fetched events
        state = AsyncValue.data(events);
      } catch (e, stackTrace) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  // Fetch events based on a schedule ID
  Future<void> loadEventsByScheduleId(int scheduleId) async {
    if (_cachedEvents != null) {
      // If events are cached, filter them directly
      final filteredEvents = _cachedEvents!
          .where((event) => event.scheduleId == scheduleId)
          .toList();
      state = AsyncValue.data(filteredEvents);
    } else {
      try {
        // Fetch all events from API
        final events = await apiService.fetchEvents();
        _cachedEvents = events; // Cache fetched events
        final filteredEvents =
            events.where((event) => event.scheduleId == scheduleId).toList();
        state = AsyncValue.data(filteredEvents);
      } catch (e, stackTrace) {
        state = AsyncValue.error(e, stackTrace);
      }
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
