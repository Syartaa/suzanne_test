import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class UpcomingWidget extends ConsumerWidget {
  const UpcomingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcastsAsyncValue = ref.watch(podcastProvider);

    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upcoming",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          // List of Podcasts
          podcastsAsyncValue.when(
            data: (podcasts) {
              return ListView.builder(
                shrinkWrap:
                    true, // Added this to prevent the list from expanding infinitely
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  final podcast = podcasts[index];
                  return _buildPodcastTile(podcast['title'],
                      podcast['host_name'], podcast['thumbnail'], true);
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcastTile(
      String title, String subtitle, String imagePath, bool isBookmarked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            // ignore: unnecessary_null_comparison
            child: imagePath != null
                ? imagePath.startsWith('http')
                    ? Image.network(
                        imagePath,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        'https://suzanne-podcast.laratest-app.com/$imagePath',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                : const Icon(
                    Icons.podcasts,
                    size: 50,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 37, 37, 37),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
            color: AppColors.secondaryColor,
          ),
        ],
      ),
    );
  }
}
