import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class FeaturedPodcastsWidget extends ConsumerWidget {
  const FeaturedPodcastsWidget({
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
              "Featured Podcasts",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: const Color.fromARGB(197, 0, 0, 0)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => PodcastScreen()));
              },
              child: Text(
                "See more",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondaryColor,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Horizontal List of Podcasts
        podcastsAsyncValue.when(
          data: (podcasts) {
            if (podcasts.isEmpty) {
              return const Center(child: Text("No Featured Podcasts found"));
            }
            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  final podcast = podcasts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
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
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.podcasts, size: 50),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 140,
                          child: Text(
                            podcast['title'] ?? 'No Title',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 140,
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
          loading: () => const FeaturedPodcastsSkeleton(),
          error: (error, stackTrace) => Center(
            child: Text("Error: ${error.toString()}"),
          ),
        ),
      ],
    );
  }
}

class FeaturedPodcastsSkeleton extends StatelessWidget {
  const FeaturedPodcastsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Skeleton placeholders count
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail Skeleton
                Shimmer.fromColors(
                  baseColor: Color(0xFFFC2221),
                  highlightColor: Color.fromARGB(255, 245, 80, 80),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color(0xFFFC2221),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Title Skeleton
                Shimmer.fromColors(
                  baseColor: Color(0xFFFC2221),
                  highlightColor: Color.fromARGB(255, 245, 80, 80),
                  child: Container(
                    width: 140,
                    height: 14,
                    color: Color(0xFFFC2221),
                  ),
                ),
                const SizedBox(height: 5),
                // Host Name Skeleton
                Shimmer.fromColors(
                  baseColor: Color(0xFFFC2221),
                  highlightColor: Color.fromARGB(255, 245, 80, 80),
                  child: Container(
                    width: 100,
                    height: 12,
                    color: Color(0xFFFC2221),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
