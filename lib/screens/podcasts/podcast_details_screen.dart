import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/favorite_provider.dart';
import 'package:suzanne_podcast_app/provider/ratings_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/widget/rating_comments_widget.dart';
import 'package:suzanne_podcast_app/utilis/constants/popup_utils.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
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
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    // Check the network connectivity status
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

  void _playPrevious() {
    if (widget.playlist != null &&
        widget.playlistIndex != null &&
        widget.playlistIndex! > 0) {
      final newIndex = widget.playlistIndex! - 1;
      _navigateToPodcast(widget.playlist![newIndex], newIndex);
    }
  }

  void _playNext() {
    if (widget.playlist != null &&
        widget.playlistIndex != null &&
        widget.playlistIndex! < widget.playlist!.length - 1) {
      final newIndex = widget.playlistIndex! + 1;
      _navigateToPodcast(widget.playlist![newIndex], newIndex);
    }
  }

  void _navigateToPodcast(Map<String, dynamic> newPodcast, int newIndex) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PodcastDetailsScreen(
          podcast: newPodcast,
          playlist: widget.playlist,
          playlistIndex: newIndex,
        ),
      ),
    );
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
            fontSize: ScreenSize.textScaler.scale(20), // Responsive font size
            color: const Color(0xFFFFF8F0),
            shadows: [
              Shadow(
                color: const Color(0xFFFFF1F1),
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
          padding:
              EdgeInsets.all(ScreenSize.width * 0.04), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(
                    ScreenSize.width * 0.04), // Responsive padding
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(
                      ScreenSize.width * 0.04), // Responsive border radius
                ),
                child: Column(
                  children: [
                    YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                    ),
                    SizedBox(
                        height: ScreenSize.height * 0.02), // Responsive spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_currentPosition),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenSize.textScaler
                                  .scale(14)), // Responsive font size
                        ),
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
                          style: TextStyle(
                            color: const Color(0xFFFFDBB5),
                            fontSize: ScreenSize.textScaler
                                .scale(14), // Responsive font size
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: ScreenSize.height * 0.02), // Responsive spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white),
                          iconSize:
                              ScreenSize.width * 0.1, // Responsive icon size
                          onPressed: (widget.playlist != null &&
                                  widget.playlistIndex != null &&
                                  widget.playlistIndex! > 0)
                              ? _playPrevious
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.replay_10),
                          color: Colors.white,
                          iconSize:
                              ScreenSize.width * 0.08, // Responsive icon size
                          onPressed: () {
                            final currentPosition =
                                _currentPosition ?? Duration.zero;
                            _controller.seekTo(
                                currentPosition - const Duration(seconds: 10));
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                          ),
                          color: AppColors.secondaryColor,
                          iconSize:
                              ScreenSize.width * 0.12, // Responsive icon size
                          onPressed: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          color: Colors.white,
                          iconSize:
                              ScreenSize.width * 0.08, // Responsive icon size
                          onPressed: () {
                            final currentPosition =
                                _currentPosition ?? Duration.zero;
                            _controller.seekTo(
                                currentPosition + const Duration(seconds: 10));
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.skip_next, color: Colors.white),
                          iconSize:
                              ScreenSize.width * 0.1, // Responsive icon size
                          onPressed: (widget.playlist != null &&
                                  widget.playlistIndex != null &&
                                  widget.playlistIndex! <
                                      widget.playlist!.length - 1)
                              ? _playNext
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(
                        height: ScreenSize.height * 0.02), // Responsive spacing
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
                          iconSize:
                              ScreenSize.width * 0.06, // Responsive icon size
                          onPressed: () {
                            ref
                                .read(favoriteProvider.notifier)
                                .toggleFavorite(podcastId);
                          },
                        ),
                        SizedBox(
                            width:
                                ScreenSize.width * 0.02), // Responsive spacing
                        IconButton(
                          icon: const Icon(Icons.playlist_add),
                          color: Colors.white,
                          iconSize:
                              ScreenSize.width * 0.06, // Responsive icon size
                          onPressed: () {
                            showFavoritePlaylistPopup(context, ref, podcastId);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenSize.height * 0.02), // Responsive spacing
              Column(
                children: [
                  Text(
                    widget.podcast['title'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenSize.textScaler
                          .scale(15), // Responsive font size
                      color: const Color(0xFFFFF8F0),
                      shadows: [
                        Shadow(
                          color: const Color(0xFFFFF1F1),
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.podcast['long_description'] != null &&
                          widget.podcast['long_description'].length > 150) {
                        setState(() => _isExpanded = !_isExpanded);
                      }
                    },
                    child: Text(
                      widget.podcast['long_description'] != null
                          ? (_isExpanded
                              ? widget.podcast['long_description']
                              : widget.podcast['long_description'].length > 150
                                  ? '${widget.podcast['long_description'].substring(0, 150)}... See more'
                                  : widget.podcast['long_description'])
                          : "No description available",
                      style: TextStyle(
                        color: const Color.fromARGB(207, 255, 255, 255),
                        fontSize: ScreenSize.textScaler
                            .scale(13), // Responsive font size
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenSize.height * 0.04), // Responsive spacing
              RatingCommentsWidget(podcastId: podcastId),
            ],
          ),
        ),
      ),
    );
  }
}
