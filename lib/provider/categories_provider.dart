import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/api_service_provider.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

class CategoriesNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  CategoriesNotifier(this.apiService) : super(const AsyncValue.loading());

  final ApiService apiService;

  Future<void> loadCategories() async {
    try {
      state = const AsyncValue.loading(); // Set the loading state
      final response = await apiService.fetchCategories();
      state = AsyncValue.data(response); // Update with fetched data
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Handle errors gracefully
    }
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, AsyncValue<List<dynamic>>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return CategoriesNotifier(apiService)..loadCategories();
});
