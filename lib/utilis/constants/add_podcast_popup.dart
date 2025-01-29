// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:suzanne_podcast_app/provider/playlist_provider.dart';
// import 'package:suzanne_podcast_app/provider/user_provider.dart';

// void showAddToPlaylistPopup(BuildContext context, WidgetRef ref, String podcastId) {
//   final userState = ref.read(userProvider);
//   final isLoggedIn = userState.value != null;
//   final playlists = ref.watch(playlistProvider);

//   TextEditingController playlistController = TextEditingController();

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return Container(
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(16.0),
//             topRight: Radius.circular(16.0),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Add to Playlist',
//               style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             // List existing playlists
//             if (playlists.isNotEmpty)
//               ...playlists.keys.map((playlistName) {
//                 final isAdded = ref.watch(playlistProvider.notifier).isPodcastInPlaylist(playlistName, podcastId);
//                 return ListTile(
//                   leading: Icon(isAdded ? Icons.check_box : Icons.check_box_outline_blank, color: Colors.white),
//                   title: Text(playlistName, style: const TextStyle(color: Colors.white)),
//                   onTap: () {
//                     ref.read(playlistProvider.notifier).togglePodcastInPlaylist(playlistName, podcastId);
//                     Navigator.of(context).pop();
//                   },
//                 );
//               }).toList(),

//             // Divider
//             const Divider(color: Colors.grey),

//             // Create new playlist
//             if (isLoggedIn) ...[
//               TextField(
//                 controller: playlistController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: 'New Playlist Name',
//                   labelStyle: const TextStyle(color: Colors.white70),
//                   enabledBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white54),
//                   ),
//                   focusedBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   final newPlaylistName = playlistController.text.trim();
//                   if (newPlaylistName.isNotEmpty) {
//                     ref.read(playlistProvider.notifier).createPlaylist(newPlaylistName);
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 child: const Text('Create Playlist'),
//               ),
//             ],
//           ],
//         ),
//       );
//     },
//   );
// }
