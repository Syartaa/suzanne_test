import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/events_provider.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/provider/schedules_provider.dart';
import 'package:suzanne_podcast_app/screens/discover/widget/top_podcast.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_details_screen.dart';
import 'package:suzanne_podcast_app/screens/schedules/schedule_details_screen.dart';
import 'package:suzanne_podcast_app/screens/event/widget/event_details_page.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final podcasts = ref.watch(podcastProvider);
    final schedules = ref.watch(schedulesNotifierProvider);
    final events = ref.watch(eventNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Center(
          child: Text(
            "Discover",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 24 * ScreenSize.textScaler.textScaleFactor,
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
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.all(16.0 * ScreenSize.textScaler.textScaleFactor),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search, color: AppColors.secondaryColor),
                filled: true,
                fillColor: const Color.fromARGB(255, 224, 6, 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                hintStyle: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(
                    16.0 * ScreenSize.textScaler.textScaleFactor),
                child: Column(
                  children: [
                    // Display TopPodcast when search query is empty
                    if (searchQuery.isEmpty)
                      const TopPodcastsWidget(), // Your previous top podcast widget here

                    // Display Podcasts Section
                    if (searchQuery.isNotEmpty)
                      podcasts.when(
                        data: (data) {
                          final filteredPodcasts = data.where((podcast) {
                            final title = podcast['title']?.toLowerCase() ?? '';
                            return title.contains(searchQuery);
                          }).toList();

                          return filteredPodcasts.isEmpty
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Text(
                                      'Podcasts',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18 *
                                              ScreenSize
                                                  .textScaler.textScaleFactor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: filteredPodcasts.length,
                                      itemBuilder: (context, index) {
                                        final podcast = filteredPodcasts[index];
                                        return ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PodcastDetailsScreen(
                                                        podcast: podcast),
                                              ),
                                            );
                                          },
                                          leading: podcast['thumbnail'] != null
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    podcast['thumbnail']
                                                                ?.startsWith(
                                                                    'http') ??
                                                            false
                                                        ? podcast['thumbnail']
                                                        : 'https://suzanne-podcast.laratest-app.com/${podcast['thumbnail']}',
                                                  ),
                                                )
                                              : const Icon(Icons.podcasts),
                                          title: Text(
                                            podcast['title'] ?? 'No Title',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            podcast['host_name'] ?? 'Unknown',
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text("Error: ${error.toString()}")),
                      ),

                    // Display Events Section
                    if (searchQuery.isNotEmpty)
                      events.when(
                        data: (eventData) {
                          final filteredEvents = eventData.where((event) {
                            final title = event.title.toLowerCase();
                            return title.contains(searchQuery);
                          }).toList();

                          return filteredEvents.isEmpty
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Text(
                                      'Events',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18 *
                                              ScreenSize
                                                  .textScaler.textScaleFactor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: filteredEvents.length,
                                      itemBuilder: (context, index) {
                                        final event = filteredEvents[index];
                                        return ListTile(
                                          title: Text(
                                            event.title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            event.eventDate,
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        EventDetailsPage(
                                                            event: event)));
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text("Error: ${error.toString()}")),
                      ),

                    // Display Schedules Section
                    if (searchQuery.isNotEmpty)
                      schedules.when(
                        data: (scheduleData) {
                          final filteredSchedules =
                              scheduleData.where((schedule) {
                            final title = schedule.title.toLowerCase();
                            return title.contains(searchQuery);
                          }).toList();

                          return filteredSchedules.isEmpty
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Text(
                                      'Monday Marks',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18 *
                                              ScreenSize
                                                  .textScaler.textScaleFactor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: filteredSchedules.length,
                                      itemBuilder: (context, index) {
                                        final schedule =
                                            filteredSchedules[index];
                                        return ListTile(
                                          title: Text(
                                            schedule.title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                            schedule.scheduleTypeName,
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ScheduleDetailsScreen(
                                                            schedule:
                                                                schedule)));
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text("Error: ${error.toString()}")),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
