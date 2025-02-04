import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';
import 'package:suzanne_podcast_app/models/user.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class PodcastRatingsNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final ApiService _apiService;
  final Ref ref;

  PodcastRatingsNotifier(this._apiService, this.ref)
      : super(const AsyncValue.loading());

  // Fetch Podcast Ratings
  Future<void> fetchPodcastRatings(String podcastId) async {
    try {
      state = const AsyncValue.loading();
      final ratings = await _apiService.getPodcastRatings(podcastId);
      state = AsyncValue.data(ratings);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Post Podcast Rating (Automatically Uses Logged-in User)
  Future<Map<String, dynamic>?> ratePodcast({
    required String podcastId,
    required int rate,
    String? comment,
  }) async {
    try {
      // Get the current user from userProvider
      final userState = ref.read(userProvider);
      final User? user = userState.value; // Extract user object if available

      if (user == null || user.token == null) {
        throw Exception("User not authenticated.");
      }

      final response = await _apiService.ratePodcast(
        podcastId: podcastId,
        rate: rate,
        comment: comment,
        authToken: user.token!, // Use the token from the logged-in user
      );

      // Refresh ratings after posting
      await fetchPodcastRatings(podcastId);

      return response; // ✅ Now it correctly returns a Map<String, dynamic>
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null; // ✅ Return null in case of an error
    }
  }
}

// ✅ Podcast Ratings Provider (Includes User Authentication)
final podcastRatingsProvider = StateNotifierProvider<PodcastRatingsNotifier,
    AsyncValue<Map<String, dynamic>>>(
  (ref) => PodcastRatingsNotifier(ref.watch(apiServiceProvider), ref),
);
