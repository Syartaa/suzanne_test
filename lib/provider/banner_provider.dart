import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/models/banner.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

// Define the provider to fetch the banners
final bannerProvider = FutureProvider<List<Banner>>((ref) async {
  final apiService = ApiService();
  return apiService.fetchBanners(); // Call the method to fetch banners
});
