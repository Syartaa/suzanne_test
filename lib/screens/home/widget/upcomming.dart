import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/popup_utils.dart';
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 24,
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
          const SizedBox(height: 16),
          podcastsAsyncValue.when(
            data: (podcasts) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  final podcast = podcasts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              PodcastDetailsScreen(podcast: podcast)));
                    },
                    child: _buildPodcastTile(
                      podcast['id'].toString(), // Pass podcast ID
                      podcast['title'],
                      podcast['host_name'],
                      podcast['thumbnail'],
                      context,
                      ref,
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcastTile(
    String podcastId,
    String title,
    String subtitle,
    String imagePath,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
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
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon:
                    const Icon(Icons.download, color: AppColors.secondaryColor),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert,
                    color: AppColors.secondaryColor),
                onPressed: () {
                  showFavoritePlaylistPopup(
                    context,
                    ref, // Pass ref for Riverpod
                    podcastId, // Pass podcast ID
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
