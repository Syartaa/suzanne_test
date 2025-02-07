import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/favorite_provider.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoriteProvider);
    final podcastState = ref.watch(podcastProvider);
    final userState = ref.watch(userProvider);

    // If user is NOT logged in, show "No favorite podcasts"
    if (userState.value == null || userState.value!.token == null) {
      return const Center(
        child: Text(
          "No favorite podcasts yet!",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    print('Favorite IDs: $favoriteIds'); // Debugging

    return podcastState.when(
      loading: () =>
          _buildShimmerLoading(), // Show shimmer skeleton while loading
      error: (err, stack) =>
          Center(child: Text("Error loading podcasts: $err")),
      data: (allPodcasts) {
        final favoritePodcasts = allPodcasts
            .where((podcast) => favoriteIds
                .contains(podcast['id'].toString())) // Ensure both are strings
            .toList();

        print('Favorite podcasts: $favoritePodcasts'); // Debugging

        return favoritePodcasts.isEmpty
            ? const Center(
                child: Text(
                  "No favorite podcasts yet!",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: favoritePodcasts.length,
                itemBuilder: (context, index) {
                  final podcast = favoritePodcasts[index];
                  final podcastId = podcast['id'].toString();
                  final isFavorited = favoriteIds.contains(podcastId);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 231, 32, 32),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            podcast['thumbnail'] ?? 'assets/images/banner4.png',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          podcast['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(242, 255, 248, 240),
                          ),
                        ),
                        subtitle: Text(
                          podcast['host_name'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppColors.secondaryColor,
                          ),
                          onPressed: () {
                            ref
                                .read(favoriteProvider.notifier)
                                .toggleFavorite(podcastId);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  // Shimmer loading widget
  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5, // Show 5 placeholder items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                title: Container(
                  width: 100,
                  height: 16,
                  color: Colors.white,
                ),
                subtitle: Container(
                  width: 70,
                  height: 12,
                  color: Colors.white,
                ),
                trailing: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
