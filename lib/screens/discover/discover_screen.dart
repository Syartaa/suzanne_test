import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/screens/discover/widget/top_podcast.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final podcasts = ref.watch(podcastProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Center(
          child: Text(
            "Discover",
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search, color: AppColors.secondaryColor),
                filled: true,
                fillColor: const Color.fromARGB(255, 224, 6, 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                hintStyle: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: podcasts.when(
              data: (data) {
                // Filter podcasts based on the search query
                final filteredPodcasts = searchQuery.isEmpty
                    ? null
                    : data.where((podcast) {
                        final title = podcast['title']?.toLowerCase() ?? '';
                        return title.contains(searchQuery);
                      }).toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        if (searchQuery.isEmpty) ...[
                          const TopPodcastsWidget(),
                        ] else if (filteredPodcasts == null ||
                            filteredPodcasts.isEmpty) ...[
                          const Center(
                            child: Text(
                              "No podcasts found.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ] else ...[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredPodcasts.length,
                            itemBuilder: (context, index) {
                              final podcast = filteredPodcasts[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PodcastDetailsScreen(
                                        podcast: podcast,
                                      ),
                                    ),
                                  );
                                },
                                leading: podcast['thumbnail'] != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          podcast['thumbnail']
                                                      ?.startsWith('http') ??
                                                  false
                                              ? podcast['thumbnail']
                                              : 'https://suzanne-podcast.laratest-app.com/${podcast['thumbnail']}',
                                        ),
                                      )
                                    : const Icon(Icons.podcasts),
                                title: Text(
                                  podcast['title'] ?? 'No Title',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  podcast['host_name'] ?? 'Unknown',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text("Error: ${error.toString()}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
