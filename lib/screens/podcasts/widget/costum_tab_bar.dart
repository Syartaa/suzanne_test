import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/categories_provider.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/popup_utils.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class CustomTabBarWidget extends ConsumerWidget {
  const CustomTabBarWidget({Key? key}) : super(key: key);

  // Function to show the popup menu

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final podcasts = ref.watch(podcastProvider);

    return Column(
      children: [
        categories.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (categoriesList) {
            // Generate Tab widgets dynamically based on fetched categories
            final tabs = categoriesList.map((category) {
              return Tab(
                child: Row(
                  children: [
                    const SizedBox(width: 8), // Space between image and text
                    Text(
                      category['name'], // Display category name in each Tab
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList();

            return DefaultTabController(
              length: categoriesList.length,
              child: Column(
                children: [
                  TabBar(
                    isScrollable:
                        true, // Makes the TabBar horizontally scrollable
                    indicatorColor: AppColors.secondaryColor,
                    indicatorWeight: 3,
                    labelColor: AppColors.secondaryColor,
                    unselectedLabelColor: Colors.white,
                    tabs: tabs, // Use the dynamically generated tabs here
                  ),
                  SizedBox(
                    height: 400, // Set a fixed height for the TabBarView
                    child: TabBarView(
                      children: categoriesList.map((category) {
                        return podcasts.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) =>
                              Center(child: Text('Error: $error')),
                          data: (podcastList) {
                            // Filter podcasts based on category
                            final filteredPodcasts = podcastList
                                .where((podcast) =>
                                    podcast['category_id'] == category['id'])
                                .toList();

                            return SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: filteredPodcasts.isEmpty
                                    ? const Center(
                                        child: Text("No podcasts found"),
                                      )
                                    : Column(
                                        children:
                                            filteredPodcasts.map((podcast) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                            child: Card(
                                              color: const Color.fromARGB(
                                                  234,
                                                  218,
                                                  29,
                                                  29), // Background color
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        podcast['thumbnail'] !=
                                                                null
                                                            ? (podcast['thumbnail']
                                                                    .startsWith(
                                                                        'http')
                                                                ? podcast[
                                                                    'thumbnail']
                                                                : 'https://suzanne-podcast.laratest-app.com/${podcast['thumbnail']}')
                                                            : '',
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              value: loadingProgress
                                                                          .expectedTotalBytes !=
                                                                      null
                                                                  ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      (loadingProgress
                                                                          .expectedTotalBytes!)
                                                                  : null,
                                                            ),
                                                          );
                                                        },
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            const Icon(
                                                                Icons
                                                                    .broken_image,
                                                                size: 80),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            podcast['title'],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFFFFF8F0),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                            podcast['short_description'] ??
                                                                '',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color: Color
                                                                  .fromARGB(
                                                                      179,
                                                                      0,
                                                                      255,
                                                                      195),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PodcastDetailsScreen(
                                                                    podcast:
                                                                        podcast),
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.play_circle_fill,
                                                        color: AppColors
                                                            .secondaryColor,
                                                        size: 40,
                                                      ),
                                                    ),
                                                    // 3 Dots IconButton to show the popup
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.more_vert,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        showFavoritePlaylistPopup(
                                                            context,
                                                            ref,
                                                            podcast['id']
                                                                .toString());
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
