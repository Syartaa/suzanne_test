import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suzanne_podcast_app/screens/home/widget/featured_podcast.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/popup_utils.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class PodcastSliderWidget extends ConsumerWidget {
  final String title;
  final String seeMoreText;
  final Widget Function(BuildContext context) routeBuilder;
  final AsyncValue<List> podcastsAsyncValue;

  const PodcastSliderWidget({
    super.key,
    required this.title,
    required this.seeMoreText,
    required this.routeBuilder,
    required this.podcastsAsyncValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: ScreenSize.width * 0.06, // Dynamic font size
                color: const Color(0xFFFFF8F0),
                shadows: [
                  const Shadow(
                    color: Color(0xFFFFF1F1), // Drop shadow color
                    offset: Offset(1.0, 1.0), // Shadow position
                    blurRadius: 3.0, // Blur effect for the shadow
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: routeBuilder));
              },
              child: Text(
                seeMoreText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondaryColor,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6), // Reduced space between title and list
        // Horizontal List of Podcasts
        podcastsAsyncValue.when(
          data: (podcasts) {
            if (podcasts.isEmpty) {
              return const Center(child: Text("No Podcasts found"));
            }
            return SizedBox(
              height: ScreenSize.height * 0.3, // Adjust height dynamically
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  final podcast = podcasts[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        right: ScreenSize.width *
                            0.01), // Reduced space between items
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
                              width: ScreenSize.width * 0.40, // Dynamic width
                              height: ScreenSize.width * 0.35, // Dynamic height
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: AppColors.primaryColor,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width:
                                      ScreenSize.width * 0.40, // Dynamic width
                                  height:
                                      ScreenSize.width * 0.35, // Dynamic height
                                  color: Colors.grey[300],
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.broken_image,
                                size: 50,
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 3), // Reduced space after the image
                          SizedBox(
                            width: ScreenSize.width * 0.37, // Dynamic width
                            child: Text(
                              podcast['title'] ?? 'No Title',
                              style: TextStyle(
                                color: Color(0xFFFFDBB5),
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenSize.width *
                                    0.04, // Dynamic text size
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Row(
                            children: [
                              SizedBox(
                                width: ScreenSize.width * 0.3, // Dynamic width
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
                              IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: AppColors.secondaryColor,
                                ),
                                onPressed: () {
                                  showFavoritePlaylistPopup(
                                    context,
                                    ref, // Pass WidgetRef for Riverpod state management
                                    podcast['id']
                                        .toString(), // Pass podcast ID for favoriting logic
                                  );
                                },
                              ),
                            ],
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
