import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class FeaturedPodcastsWidget extends ConsumerWidget {
  const FeaturedPodcastsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcastsAsyncValue = ref.watch(podcastProvider);
    final double itemWidth = ScreenSize.width * 0.4;
    final double itemHeight = ScreenSize.height * 0.25;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Featured Podcasts",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: ScreenSize.textScaler.scale(24),
                color: const Color(0xFFFFF8F0),
                shadows: [
                  const Shadow(
                    color: Color(0xFFFFF1F1),
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const PodcastScreen()));
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
        podcastsAsyncValue.when(
          data: (podcasts) {
            if (podcasts.isEmpty) {
              return const Center(child: Text("No Featured Podcasts found"));
            }
            return SizedBox(
              height: itemHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  final podcast = podcasts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                PodcastDetailsScreen(podcast: podcast)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: podcast['thumbnail']
                                          ?.startsWith('http') ==
                                      true
                                  ? podcast['thumbnail']
                                  : 'https://suzanne-podcast.laratest-app.com/${podcast['thumbnail']}',
                              width: itemWidth,
                              height: itemWidth,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: AppColors.primaryColor,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: itemWidth,
                                  height: itemWidth,
                                  color: Colors.grey[300],
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.broken_image,
                                size: 50,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: itemWidth,
                            child: Text(
                              podcast['title'] ?? 'No Title',
                              style: TextStyle(
                                color: const Color(0xFFFFDBB5),
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenSize.textScaler.scale(14),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: Text(
                              podcast['host_name'] ?? 'Unknown',
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontSize: ScreenSize.textScaler.scale(12),
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
    ScreenSize.init(context);
    final double itemWidth = ScreenSize.width * 0.4;
    return SizedBox(
      height: ScreenSize.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Shimmer.fromColors(
            baseColor: AppColors.primaryColor,
            highlightColor: Colors.grey[100]!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                width: itemWidth,
                height: itemWidth,
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
