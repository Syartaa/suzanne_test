import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/models/events.dart';
import 'package:suzanne_podcast_app/provider/events_provider.dart';
import 'package:suzanne_podcast_app/screens/event/widget/event_details_page.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:shimmer/shimmer.dart';

class EventTab extends ConsumerWidget {
  const EventTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScreenSize.init(context);
    final eventAsyncValue = ref.watch(eventNotifierProvider);

    return Container(
      color: Colors.red, // Background color for the tab
      padding: EdgeInsets.all(ScreenSize.width * 0.04),
      child: eventAsyncValue.when(
        data: (events) {
          return events.isEmpty
              ? Center(
                  child: Text(
                    "No events available",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenSize.textScaler.scale(16),
                    ),
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
        error: (error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: TextStyle(
              fontSize: ScreenSize.textScaler.scale(14),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 10, // Show 10 shimmer placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenSize.height * 0.01),
          child: Shimmer.fromColors(
            baseColor: AppColors.primaryColor!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              children: [
                Container(
                  width: ScreenSize.width * 0.15,
                  height: ScreenSize.width * 0.15,
                  color: Colors.white,
                ),
                SizedBox(width: ScreenSize.width * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: ScreenSize.height * 0.02,
                        color: Colors.white,
                      ),
                      SizedBox(height: ScreenSize.height * 0.01),
                      Container(
                        width: ScreenSize.width * 0.25,
                        height: ScreenSize.height * 0.015,
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

  Widget _buildEventTile(Event event) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenSize.height * 0.01),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: event.image != null
                ? Image.network(
                    event.image.startsWith('http')
                        ? event.image
                        : 'https://suzanne-podcast.laratest-app.com/${event.image}',
                    width: ScreenSize.width * 0.15,
                    height: ScreenSize.width * 0.15,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.event,
                    size: 50,
                  ),
          ),
          SizedBox(width: ScreenSize.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: ScreenSize.textScaler.scale(15),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  event.eventDate,
                  style: TextStyle(
                    fontSize: ScreenSize.textScaler.scale(12),
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
