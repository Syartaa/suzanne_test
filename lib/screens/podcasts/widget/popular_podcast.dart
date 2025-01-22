import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';

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
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: const Color.fromARGB(197, 0, 0, 0)),
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
                              color: Color(0xFFFFF748),
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
