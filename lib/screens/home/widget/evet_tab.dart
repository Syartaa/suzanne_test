import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/models/events.dart';
import 'package:suzanne_podcast_app/provider/events_provider.dart';
import 'package:suzanne_podcast_app/screens/event/widget/event_details_page.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:shimmer/shimmer.dart';

class EventTab extends ConsumerWidget {
  const EventTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsyncValue = ref.watch(eventNotifierProvider);

    return Container(
      color: Colors.red, // Background color for the tab
      padding: const EdgeInsets.all(16.0),
      child: eventAsyncValue.when(
        data: (events) {
          return events.isEmpty
              ? Center(
                  child: Text(
                    "No events available",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EventDetailsPage(event: event),
                          ),
                        );
                      },
                      child: _buildEventTile(event),
                    );
                  },
                );
        },
        loading: () => _buildShimmerEffect(),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  // Function to create shimmer effect when loading
  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 10, // Show 10 shimmer placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: AppColors.primaryColor!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Builds event tile UI
  Widget _buildEventTile(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: event.image != null
                ? Image.network(
                    event.image.startsWith('http')
                        ? event.image
                        : 'https://suzanne-podcast.laratest-app.com/${event.image}',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.event,
                    size: 50,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  event.eventDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
