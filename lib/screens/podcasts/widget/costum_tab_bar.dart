import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/categories_provider.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/popup_utils.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class CustomTabBarWidget extends ConsumerWidget {
  const CustomTabBarWidget({super.key});

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
            final tabs = categoriesList.map((category) {
              return Tab(
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      category['name'],
                      style: TextStyle(
                        fontSize: ScreenSize.textScaler
                            .scale(16), // Responsive font size
                      ),
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
                    isScrollable: true,
                    indicatorColor: AppColors.secondaryColor,
                    indicatorWeight: 3,
                    labelColor: AppColors.secondaryColor,
                    unselectedLabelColor: Colors.white,
                    tabs: tabs,
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.6, // Responsive height
                    child: TabBarView(
                      children: categoriesList.map((category) {
                        return podcasts.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) =>
                              Center(child: Text('Error: $error')),
                          data: (podcastList) {
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
                                        child: Text("No podcasts found"))
                                    : Column(
                                        children:
                                            filteredPodcasts.map((podcast) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                            child: Card(
                                              color: const Color.fromARGB(
                                                  234, 218, 29, 29),
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
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
                                                        width: ScreenSize
                                                                .width *
                                                            0.2, // Responsive width
                                                        height: ScreenSize
                                                                .width *
                                                            0.2, // Responsive height
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
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
                                                            _shortenTitle(
                                                                podcast[
                                                                    'title']),
                                                            style: TextStyle(
                                                              fontSize: ScreenSize
                                                                  .textScaler
                                                                  .scale(
                                                                      14), // Responsive font size
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: const Color(
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
                                                            style: TextStyle(
                                                              fontSize: ScreenSize
                                                                  .textScaler
                                                                  .scale(
                                                                      12), // Responsive font size
                                                              color: const Color
                                                                  .fromARGB(179,
                                                                  0, 255, 195),
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
                                                      icon: Icon(
                                                        Icons.play_circle_fill,
                                                        color: AppColors
                                                            .secondaryColor,
                                                        size: ScreenSize.width *
                                                            0.1, // Responsive icon size
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.more_vert,
                                                        color: Colors.white,
                                                        size: ScreenSize.width *
                                                            0.08, // Responsive icon size
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

  String _shortenTitle(String title) {
    List<String> words = title.split(' ');
    if (words.length > 3) {
      return '${words.sublist(0, 3).join(' ')}...';
    }
    return title;
  }
}
