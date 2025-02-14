import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/playlist_provider.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class PlaylistPodcastPlayerScreen extends ConsumerStatefulWidget {
  final String playlistName;
  final List<Map<String, dynamic>> playlistPodcasts;
  final int startIndex;

  const PlaylistPodcastPlayerScreen({
    Key? key,
    required this.playlistName,
    required this.playlistPodcasts,
    required this.startIndex,
  }) : super(key: key);

  @override
  ConsumerState<PlaylistPodcastPlayerScreen> createState() =>
      _PlaylistPodcastPlayerScreenState();
}

class _PlaylistPodcastPlayerScreenState
    extends ConsumerState<PlaylistPodcastPlayerScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
  }

  void _playNext() {
    if (_currentIndex < widget.playlistPodcasts.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _playPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPodcast = widget.playlistPodcasts[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        centerTitle: true,
        title: Text(
          widget.playlistName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFFFFF8F0),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: currentPodcast['thumbnail'] != null
                      ? Image.network(
                          currentPodcast['thumbnail'].startsWith('http')
                              ? currentPodcast['thumbnail']
                              : 'https://suzanne-podcast.laratest-app.com/${currentPodcast['thumbnail']}',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.podcasts,
                          size: 100, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  currentPodcast['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  currentPodcast['host_name'] ?? "Unknown Host",
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous,
                    size: 40, color: Colors.white),
                onPressed: _currentIndex > 0 ? _playPrevious : null,
              ),
              IconButton(
                icon: const Icon(Icons.play_circle_fill,
                    size: 60, color: Colors.white),
                onPressed: () {
                  // Handle play functionality
                  print("Playing: ${currentPodcast['audio_url']}");
                },
              ),
              IconButton(
                icon:
                    const Icon(Icons.skip_next, size: 40, color: Colors.white),
                onPressed: _currentIndex < widget.playlistPodcasts.length - 1
                    ? _playNext
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
