import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PodcastDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> podcast;

  const PodcastDetailsScreen({super.key, required this.podcast});

  @override
  State<PodcastDetailsScreen> createState() => _PodcastDetailsScreenState();
}

class _PodcastDetailsScreenState extends State<PodcastDetailsScreen> {
  late YoutubePlayerController _controller;
  Duration? _videoDuration;
  Duration? _currentPosition;

  @override
  void initState() {
    super.initState();

    // Extract the YouTube video ID from the URL
    final String? videoUrl = widget.podcast['audio_url'];
    final videoId = YoutubePlayer.convertUrlToId(videoUrl ?? "");

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    // Listen to the video position and duration
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _currentPosition = _controller.value.position;
          _videoDuration = _controller.value.metaData.duration;
        });
      }
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
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Text(
          widget.podcast['title'],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color(0xFFFFF8F0),
            shadows: [
              Shadow(
                color: Color(0xFFFFF1F1), // Drop shadow color (light pink)
                offset: Offset(1.0, 1.0), // Shadow position
                blurRadius: 3.0, // Blur effect for the shadow
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // YouTube Player
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                ),
              ),
              const SizedBox(height: 16),
              // Audio Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_currentPosition),
                    style: const TextStyle(color: Color(0xFFFFDBB5)),
                  ),
                  Expanded(
                    child: _videoDuration != null &&
                            _videoDuration!.inSeconds > 0
                        ? Slider(
                            value: (_currentPosition?.inSeconds.toDouble() ??
                                    0.0)
                                .clamp(
                                    0.0, _videoDuration!.inSeconds.toDouble()),
                            max: _videoDuration!.inSeconds.toDouble(),
                            onChanged: (value) {
                              _controller
                                  .seekTo(Duration(seconds: value.toInt()));
                            },
                            activeColor: AppColors.secondaryColor,
                            inactiveColor: Colors.grey,
                          )
                        : const SizedBox(), // Display an empty space or a placeholder if duration is not available
                  ),
                  Text(
                    _formatDuration(_videoDuration),
                    style: const TextStyle(color: Color(0xFFFFDBB5)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10),
                    color: Color(0xFFFFF8F0),
                    onPressed: () {
                      final currentPosition = _currentPosition ?? Duration.zero;
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
                    iconSize: 50,
                    onPressed: () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_10),
                    color: Color(0xFFFFF8F0),
                    onPressed: () {
                      final currentPosition = _currentPosition ?? Duration.zero;
                      _controller.seekTo(
                          currentPosition + const Duration(seconds: 10));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Star Rating Section
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: const Icon(Icons.star_border),
                    color: AppColors.secondaryColor,
                    onPressed: () {
                      // Handle star rating logic here
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Comment Section
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(204, 233, 55, 55),
                  hintText: "Leave a comment here",
                  hintStyle: TextStyle(color: Color(0xFFFFF8F0), fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
