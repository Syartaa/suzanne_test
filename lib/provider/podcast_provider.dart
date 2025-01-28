import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class PodcastNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  PodcastNotifier(this.apiService) : super(const AsyncValue.loading());

  final ApiService apiService;

  Future<void> loadPodcasts() async {
    // Check if the data is already loaded and return early if so
    if (state is AsyncData<List<dynamic>> &&
        (state as AsyncData<List<dynamic>>).value.isNotEmpty) {
      print("Podcasts already loaded, skipping fetch.");
      return; // Skip fetching if data is already loaded
    }

    try {
      state = const AsyncValue.loading(); // Set loading state
      final response = await apiService.fetchPodcasts();
      state = AsyncValue.data(response); // Update with fetched data
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Handle errors gracefully
    }
  }
}

final podcastProvider =
    StateNotifierProvider<PodcastNotifier, AsyncValue<List<dynamic>>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return PodcastNotifier(apiService)..loadPodcasts();
});
