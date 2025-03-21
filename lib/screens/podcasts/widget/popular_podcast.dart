import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class PopularPodcastsWidget extends ConsumerWidget {
  const PopularPodcastsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcastsAsyncValue = ref.watch(podcastProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Most popular podcast",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: ScreenSize.width > 600 ? 24 : 22, // Adjust font size
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
        const SizedBox(height: 20),
        // Horizontal List of Podcasts
        podcastsAsyncValue.when(
          data: (podcasts) {
            if (podcasts.isEmpty) {
              return const Center(child: Text("No Featured Podcasts found"));
            }
            return SizedBox(
              height: ScreenSize.width > 600
                  ? 250
                  : 200, // Adjust height for larger screens
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  final podcast = podcasts[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        right: ScreenSize.width > 600
                            ? 24.0
                            : 16.0), // Adjust padding
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
                                  width: ScreenSize.width > 600
                                      ? 160
                                      : 140, // Adjust image width
                                  height: ScreenSize.width > 600
                                      ? 160
                                      : 140, // Adjust image height
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.podcasts, size: 50),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: ScreenSize.width > 600
                              ? 160
                              : 140, // Adjust text width
                          child: Text(
                            podcast['title'] ?? 'No Title',
                            style: TextStyle(
                              color: Color(0xFFFFF8F0),
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenSize.width > 600
                                  ? 16
                                  : 14, // Adjust text size
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: ScreenSize.width > 600
                              ? 160
                              : 140, // Adjust text width
                          child: Text(
                            podcast['host_name'] ?? 'Unknown',
                            style: const TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
