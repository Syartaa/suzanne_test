import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/download_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class DownloadsTab extends ConsumerWidget {
  const DownloadsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadedPodcasts =
        ref.watch(downloadProvider); // Watch downloaded podcasts

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: downloadedPodcasts.isEmpty
          ? const Center(
              child: Text(
                "No downloaded podcasts yet!",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: downloadedPodcasts.length,
              itemBuilder: (context, index) {
                final podcast = downloadedPodcasts[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 231, 32, 32),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          podcast.thumbnail ?? 'assets/images/banner4.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        podcast.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(242, 255, 248, 240),
                        ),
                      ),
                      subtitle: Text(
                        podcast.title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.download_done,
                          color: AppColors.secondaryColor,
                        ),
                        onPressed: () {
                          ref
                              .read(downloadProvider.notifier)
                              .removeDownload(podcast.id);
                        },
                      ),
                      onTap: () {
                        // Navigate to PodcastDetailsScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PodcastDetailsScreen(podcast: podcast.toMap()),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
