import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/favorite_provider.dart';
import 'package:suzanne_podcast_app/provider/ratings_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/widget/rating_comments_widget.dart';
import 'package:suzanne_podcast_app/utilis/constants/popup_utils.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PodcastDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> podcast;
  final int? playlistIndex;
  final List<Map<String, dynamic>>? playlist;

  const PodcastDetailsScreen({
    super.key,
    required this.podcast,
    this.playlist,
    this.playlistIndex,
  });

  @override
  ConsumerState<PodcastDetailsScreen> createState() =>
      _PodcastDetailsScreenState();
}

class _PodcastDetailsScreenState extends ConsumerState<PodcastDetailsScreen> {
  late YoutubePlayerController _controller;
  Duration? _videoDuration;
  Duration? _currentPosition;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();

    Connectivity().checkConnectivity().then((connectivityResult) {
      setState(() {
        isOffline = connectivityResult == ConnectivityResult.none;
      });
    });

    final videoUrl = widget.podcast['audio_url'];
    final videoId = YoutubePlayer.convertUrlToId(videoUrl ?? "");

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _currentPosition = _controller.value.position;
          _videoDuration = _controller.metadata.duration;
        });
      }
    });

    Future.microtask(() {
      ref
          .read(podcastRatingsProvider.notifier)
          .fetchPodcastRatings(widget.podcast['id'].toString());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "0:00";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final podcastId = widget.podcast['id'].toString();
    final isFavorited = ref.watch(favoriteProvider).contains(podcastId);
    bool isFromPlaylist = widget.playlistIndex != null;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Text(
          isFromPlaylist ? "Playing from Playlist" : widget.podcast['title'],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color(0xFFFFF8F0),
            shadows: [
              Shadow(
                color: Color(0xFFFFF1F1),
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_currentPosition),
                            style: TextStyle(color: Colors.white)),
                        Expanded(
                          child: _videoDuration != null &&
                                  _videoDuration!.inSeconds > 0
                              ? Slider(
                                  value: (_currentPosition?.inSeconds
                                              .toDouble() ??
                                          0.0)
                                      .clamp(0.0,
                                          _videoDuration!.inSeconds.toDouble()),
                                  max: _videoDuration!.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    final newPosition =
                                        Duration(seconds: value.toInt());
                                    _controller.seekTo(newPosition);
                                  },
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                )
                              : const SizedBox(),
                        ),
                        Text(
                          _formatDuration(_videoDuration),
                          style: const TextStyle(color: Color(0xFFFFDBB5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorited
                                ? AppColors.secondaryColor
                                : Colors.white,
                          ),
                          iconSize: 25,
                          onPressed: () {
                            ref
                                .read(favoriteProvider.notifier)
                                .toggleFavorite(podcastId.toString());
                          },
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          icon: const Icon(Icons.playlist_add),
                          color: Colors.white,
                          iconSize: 25,
                          onPressed: () {
                            showFavoritePlaylistPopup(context, ref, podcastId);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              RatingCommentsWidget(podcastId: podcastId),
            ],
          ),
        ),
      ),
    );
  }
}
