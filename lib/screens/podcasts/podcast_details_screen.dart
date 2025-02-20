import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/favorite_provider.dart';
import 'package:suzanne_podcast_app/provider/download_provider.dart';
import 'package:suzanne_podcast_app/provider/ratings_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/widget/rating_comments_widget.dart';
import 'package:suzanne_podcast_app/utilis/constants/popup_utils.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

class PodcastDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> podcast;
  final int? playlistIndex; // Index of the current podcast in the playlist
  final List<Map<String, dynamic>>? playlist; // Full playlist

  const PodcastDetailsScreen(
      {super.key, required this.podcast, this.playlist, this.playlistIndex});

  @override
  ConsumerState<PodcastDetailsScreen> createState() =>
      _PodcastDetailsScreenState();
}

class _PodcastDetailsScreenState extends ConsumerState<PodcastDetailsScreen> {
  late YoutubePlayerController _controller;
  VideoPlayerController? _videoController;
  Duration? _videoDuration;
  Duration? _currentPosition;
  String? localPath;

  bool isOffline = false;

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
    _videoController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _initializeLocalVideo(String path) {
    File file = File(path);
    if (!file.existsSync()) {
      print("Error: File does not exist at path: $path");
      return;
    }

    _videoController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {
          _videoDuration = _videoController!.value.duration;
        });

        // 🔹 Restore previous position if available
        if (_currentPosition != null) {
          _videoController!.seekTo(_currentPosition!);
        }

        print("Local video initialized. Duration: $_videoDuration");
      }).catchError((error) {
        print("Error initializing video: $error");
      });

    _videoController!.addListener(() {
      if (mounted) {
        setState(() {
          _currentPosition = _videoController!.value.position;
        });
      }
    });
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
    final downloadedPodcastPaths =
        ref.read(downloadProvider.notifier).downloadedPodcastPaths;
    localPath = downloadedPodcastPaths[podcastId];

    // Initialize the local video only if the file exists
    if (localPath != null &&
        File(localPath!).existsSync() &&
        _videoController == null) {
      _initializeLocalVideo(localPath!);
    }

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
                    localPath != null && File(localPath!).existsSync()
                        ? _videoController != null &&
                                _videoController!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              )
                            : const CircularProgressIndicator()
                        : YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true),
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
                                    if (localPath == null) {
                                      _controller.seekTo(newPosition);
                                    } else {
                                      _videoController?.seekTo(newPosition);
                                    }
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white),
                          iconSize: 40,
                          onPressed: (widget.playlist != null &&
                                  widget.playlistIndex != null &&
                                  widget.playlistIndex! > 0)
                              ? _playPrevious
                              : null, // Disable button when at the first podcast
                        ),
                        IconButton(
                          icon: const Icon(Icons.replay_10),
                          color: Colors.white,
                          onPressed: () {
                            final currentPosition =
                                _currentPosition ?? Duration.zero;
                            if (localPath == null) {
                              _controller.seekTo(currentPosition -
                                  const Duration(seconds: 10));
                            } else {
                              _videoController?.seekTo(currentPosition -
                                  const Duration(seconds: 10));
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            localPath == null
                                ? (_controller.value.isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill)
                                : (_videoController?.value.isPlaying ?? false
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill),
                          ),
                          color: AppColors.secondaryColor,
                          iconSize: 50,
                          onPressed: () {
                            setState(() {
                              if (localPath == null) {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              } else {
                                if (_videoController?.value.isPlaying ??
                                    false) {
                                  _videoController?.pause();
                                } else {
                                  // 🔹 Resume from last known position
                                  if (_currentPosition != null) {
                                    _videoController?.seekTo(_currentPosition!);
                                  }
                                  _videoController?.play();
                                }
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          color: Colors.white,
                          onPressed: () {
                            final currentPosition =
                                _currentPosition ?? Duration.zero;
                            if (localPath == null) {
                              _controller.seekTo(currentPosition +
                                  const Duration(seconds: 10));
                            } else {
                              _videoController?.seekTo(currentPosition +
                                  const Duration(seconds: 10));
                            }
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.skip_next, color: Colors.white),
                          iconSize: 40,
                          onPressed: (widget.playlist != null &&
                                  widget.playlistIndex != null &&
                                  widget.playlistIndex! <
                                      widget.playlist!.length - 1)
                              ? _playNext
                              : null, // Disable button when at the last podcast
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Favorite and Playlist Icons
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
                            // Show the playlist popup
                            showFavoritePlaylistPopup(context, ref, podcastId);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Comment Section
              RatingCommentsWidget(podcastId: podcastId),
            ],
          ),
        ),
      ),
    );
  }
}
