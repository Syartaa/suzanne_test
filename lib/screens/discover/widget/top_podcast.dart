import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class TopPodcastsWidget extends ConsumerWidget {
  const TopPodcastsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcastsAsyncValue = ref.watch(podcastProvider);
    final loc = AppLocalizations.of(context)!;
    final textScaleFactor = ScreenSize.textScaler.textScaleFactor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.todaysTop5Podcasts,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 24 * textScaleFactor, // Scaled font size
                color: Color(0xFFFFF8F0),
                shadows: [
                  Shadow(
                    color: Color(0xFFFFF1F1), // Drop shadow color (light pink)
                    offset: Offset(1.0, 1.0), // Shadow position
                    blurRadius: 3.0, // Blur effect for the shadow
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20 * textScaleFactor), // Scaled spacing

        // Horizontal List of Podcasts
        podcastsAsyncValue.when(
          data: (podcasts) {
            if (podcasts.isEmpty) {
              return Center(child: Text(loc.noFeaturedPodcastsFound));
            }

            // Show only the first 5 podcasts
            final topPodcasts = podcasts.take(5).toList();

            return SizedBox(
              height: 300 *
                  ScreenSize.height /
                  800, // Adjust based on screen height
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topPodcasts.length,
                itemBuilder: (context, index) {
                  final podcast = topPodcasts[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        right: 16.0 * ScreenSize.width / 375), // Scaled padding
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the Podcast Details screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                PodcastDetailsScreen(podcast: podcast),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: podcast['thumbnail'] != null
                                ? Image.network(
                                    podcast['thumbnail'].startsWith('http')
                                        ? podcast['thumbnail']
                                        : 'https://suzanne-podcast.laratest-app.com/${podcast['thumbnail']}',
                                    width: 200 *
                                        ScreenSize.width /
                                        375, // Scaled width
                                    height: 200 *
                                        ScreenSize.height /
                                        800, // Scaled height
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.podcasts, size: 50),
                          ),
                          SizedBox(
                              height: 5 * textScaleFactor), // Scaled spacing
                          SizedBox(
                            width: 140 * ScreenSize.width / 375, // Scaled width
                            child: Text(
                              podcast['title'] ?? 'No Title',
                              style: TextStyle(
                                color: Color(0xFFFFDBB5),
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    14 * textScaleFactor, // Scaled font size
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 140 * ScreenSize.width / 375, // Scaled width
                            child: Text(
                              podcast['host_name'] ?? 'Unknown',
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontSize:
                                    12 * textScaleFactor, // Scaled font size
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text("Error: ${error.toString()}"),
          ),
        ),
      ],
    );
  }
}
