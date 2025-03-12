import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/provider/favorite_provider.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/provider/user_provider.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoriteProvider);
    final podcastState = ref.watch(podcastProvider);
    final userState = ref.watch(userProvider);
    final loc = AppLocalizations.of(context)!;

    // If user is NOT logged in, show "No favorite podcasts"
    if (userState.value == null || userState.value!.token == null) {
      return Center(
        child: Text(
          loc.noFavoritePodcastsYet,
          style: TextStyle(
            color: Colors.white70,
            fontSize: ScreenSize.textScaler.scale(16), // Scaled font size
          ),
        ),
      );
    }

    return podcastState.when(
      loading: () =>
          _buildShimmerLoading(), // Show shimmer skeleton while loading podcasts
      error: (err, stack) =>
          Center(child: Text("Error loading podcasts: $err")),
      data: (allPodcasts) {
        // Get favorite podcasts
        final favoritePodcasts = allPodcasts
            .where((podcast) => favoriteIds.contains(podcast['id'].toString()))
            .toList();

        return favoriteIds.isEmpty &&
                !ref.read(favoriteProvider.notifier).isLoading
            ? Center(
                child: Text(
                  loc.noFavoritePodcastsYet,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize:
                        ScreenSize.textScaler.scale(16), // Scaled font size
                  ),
                ),
              )
            : ListView.builder(
                itemCount: favoritePodcasts.length,
                itemBuilder: (context, index) {
                  final podcast = favoritePodcasts[index];
                  final podcastId = podcast['id'].toString();
                  final isFavorited = favoriteIds.contains(podcastId);

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            8.0 * ScreenSize.height / 800), // Scaled padding
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 231, 32, 32),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(
                            10 * ScreenSize.width / 375), // Scaled padding
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            podcast['thumbnail'] ?? 'assets/images/banner4.png',
                            width: 70 * ScreenSize.width / 375, // Scaled width
                            height:
                                70 * ScreenSize.height / 800, // Scaled height
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          podcast['title'],
                          style: TextStyle(
                            fontSize: ScreenSize.textScaler
                                .scale(16), // Scaled font size
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(242, 255, 248, 240),
                          ),
                        ),
                        subtitle: Text(
                          podcast['host_name'],
                          style: TextStyle(
                            fontSize: ScreenSize.textScaler
                                .scale(12), // Scaled font size
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
          padding: EdgeInsets.symmetric(
              vertical: 8.0 * ScreenSize.height / 800), // Scaled padding
          child: Shimmer.fromColors(
            baseColor: AppColors.primaryColor,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(
                    10 * ScreenSize.width / 375), // Scaled padding
                leading: Container(
                  width: 70 * ScreenSize.width / 375, // Scaled width
                  height: 70 * ScreenSize.height / 800, // Scaled height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                title: Container(
                  width: 100 * ScreenSize.width / 375, // Scaled width
                  height: 16 * ScreenSize.height / 800, // Scaled height
                  color: Colors.white,
                ),
                subtitle: Container(
                  width: 70 * ScreenSize.width / 375, // Scaled width
                  height: 12 * ScreenSize.height / 800, // Scaled height
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
