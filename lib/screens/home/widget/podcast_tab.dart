import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/provider/download_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/popup_utils.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:suzanne_podcast_app/models/podcasts.dart';

class PodcastTab extends ConsumerWidget {
  const PodcastTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcastsAsyncValue = ref.watch(podcastProvider);
    final downloads = ref.watch(downloadProvider);

    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(16.0),
      child: podcastsAsyncValue.when(
        data: (podcasts) {
          return podcasts.isEmpty
              ? Center(
                  child: Text(
                    "No podcasts available",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
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
                        podcast,
                        context,
                        ref,
                        downloads.any((d) => d.id == podcast['id'].toString()),
                      ),
                    );
                  },
                );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildPodcastTile(
    Map<String, dynamic> podcast,
    BuildContext context,
    WidgetRef ref,
    bool isDownloaded,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: podcast['thumbnail'] != null
                ? Image.network(
                    podcast['thumbnail'].startsWith('http')
                        ? podcast['thumbnail']
                        : 'https://suzanne-podcast.laratest-app.com/${podcast['thumbnail']}',
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
                  podcast['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  podcast['host_name'],
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
            children: [
              IconButton(
                icon: Icon(
                  isDownloaded ? Icons.download_done : Icons.download,
                  color: AppColors.secondaryColor,
                ),
                onPressed: () {
                  if (!isDownloaded) {
                    final podcastObj = Podcast(
                      id: podcast['id'].toString(),
                      title: podcast['title'],
                      shortDescription: podcast['short_description'],
                      longDescription: podcast['long_description'],
                      hostName: podcast['host_name'],
                      categoryId: podcast['category_id'],
                      thumbnail: podcast['thumbnail'],
                      audioUrl: podcast['audio_url'],
                      status: podcast['status'],
                    );

                    ref
                        .read(downloadProvider.notifier)
                        .downloadPodcast(podcastObj);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert,
                    color: AppColors.secondaryColor),
                onPressed: () {
                  showFavoritePlaylistPopup(
                    context,
                    ref,
                    podcast['id'].toString(),
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
