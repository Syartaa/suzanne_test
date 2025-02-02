import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzanne_podcast_app/models/podcasts.dart';
import 'package:suzanne_podcast_app/models/user.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'user_provider.dart';

class DownloadNotifier extends StateNotifier<List<Podcast>> {
  DownloadNotifier(this.ref) : super([]) {
    _loadDownloads();
  }

  final Ref ref;
  Map<String, String> downloadedPodcastPaths = {};

  // Function to extract the video ID from the YouTube URL
  String? extractVideoId(String url) {
    final uri = Uri.parse(url);

    // Remove any query parameters except for 'v'
    final videoId = uri.queryParameters['v'];
    print("Extracted Video ID: $videoId");

    return videoId;
  }

  Future<void> _loadDownloads() async {
    final userState = ref.watch(userProvider);
    final prefs = await SharedPreferences.getInstance();

    if (userState.value != null) {
      final userId = userState.value!.id;
      final downloadsJson = prefs.getStringList('downloads_$userId') ?? [];

      state = downloadsJson
          .map((podcastString) => Podcast.fromMap(jsonDecode(podcastString)))
          .toList();

      final pathsJson = prefs.getString('downloaded_paths_$userId');
      if (pathsJson != null) {
        downloadedPodcastPaths =
            Map<String, String>.from(jsonDecode(pathsJson));
      }
    }
  }

  Future<void> downloadPodcast(Podcast podcast) async {
    final userState = ref.read(userProvider);
    if (userState.value == null) {
      print("User must be logged in to download podcasts.");
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${podcast.id.toString()}.mp4';

      // Extract the video ID from the URL
      final videoId = extractVideoId(podcast.audioUrl);

      if (videoId == null) {
        print("Invalid YouTube URL: ${podcast.audioUrl}");
        return;
      }

      final yt = YoutubeExplode();
      final manifest =
          await yt.videos.streamsClient.getManifest(VideoId(videoId));

      // Check if muxed streams are available, if not, try audio streams
      StreamInfo? streamInfo;
      if (manifest.muxed.isNotEmpty) {
        streamInfo = manifest.muxed.withHighestBitrate();
      } else if (manifest.audio.isNotEmpty) {
        streamInfo = manifest.audio.withHighestBitrate();
      }

      if (streamInfo != null) {
        final stream = yt.videos.streamsClient.get(streamInfo);
        final file = File(filePath);
        final fileSink = file.openWrite();

        await stream.pipe(fileSink);
        await fileSink.flush();
        await fileSink.close();

        downloadedPodcastPaths[podcast.id.toString()] = filePath;
        state = [...state, podcast];
        await _saveDownloads();

        print("Podcast downloaded: ${podcast.title}");
      } else {
        print(
            "No available audio or video streams found for video ID: $videoId");
      }
    } catch (e) {
      print("Download failed: $e");
      print("Podcast URL: ${podcast.audioUrl}");
    }
  }

  Future<void> removeDownload(String podcastId) async {
    downloadedPodcastPaths.remove(podcastId.toString());
    state =
        state.where((podcast) => podcast.id.toString() != podcastId).toList();
    await _saveDownloads();
  }

  Future<void> _saveDownloads() async {
    final userState = ref.read(userProvider);
    final prefs = await SharedPreferences.getInstance();

    if (userState.value != null) {
      final userId = userState.value!.id;
      final downloadsJson =
          state.map((podcast) => jsonEncode(podcast.toMap())).toList();
      await prefs.setStringList('downloads_$userId', downloadsJson);
      await prefs.setString(
          'downloaded_paths_$userId', jsonEncode(downloadedPodcastPaths));
    }
  }

  Future<void> resetDownloads(User? user) async {
    state = [];
    downloadedPodcastPaths.clear();
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      await prefs.remove('downloads_${user.id}');
    }
  }
}

final downloadProvider =
    StateNotifierProvider<DownloadNotifier, List<Podcast>>((ref) {
  return DownloadNotifier(ref);
});
