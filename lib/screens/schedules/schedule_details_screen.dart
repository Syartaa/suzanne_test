import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/models/schedule.dart';
import 'package:suzanne_podcast_app/provider/events_provider.dart';
import 'package:suzanne_podcast_app/screens/event/widget/event_details_page.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class ScheduleDetailsScreen extends ConsumerStatefulWidget {
  final Schedule schedule;

  const ScheduleDetailsScreen({super.key, required this.schedule});

  @override
  ConsumerState<ScheduleDetailsScreen> createState() =>
      _ScheduleDetailsScreenState();
}

class _ScheduleDetailsScreenState extends ConsumerState<ScheduleDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(eventNotifierProvider.notifier)
          .loadEventsByScheduleId(widget.schedule.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Text(
          widget.schedule.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: ScreenSize.textScaler.scale(24), // Responsive font size
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ** Schedule Image **
              if (widget.schedule.images.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      ScreenSize.width * 0.02), // Responsive border radius
                  child: Image.network(
                    widget.schedule.images,
                    height: ScreenSize.height * 0.25, // Responsive height
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: ScreenSize.height * 0.02), // Responsive spacing

              // ** Schedule Title **
              Text(
                widget.schedule.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize:
                      ScreenSize.textScaler.scale(20), // Responsive font size
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
              SizedBox(height: ScreenSize.height * 0.01), // Responsive spacing

              // ** Schedule Description **
              Text(
                widget.schedule.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: ScreenSize.textScaler
                          .scale(14), // Responsive font size
                    ),
              ),
              SizedBox(height: ScreenSize.height * 0.02), // Responsive spacing

              // ** Events Section **
              Text(
                'Events:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: ScreenSize.textScaler
                          .scale(18), // Responsive font size
                    ),
              ),
              SizedBox(height: ScreenSize.height * 0.01), // Responsive spacing

              // ** Handle Loading, Data, and Error States **
              eventsState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Center(child: Text("Error loading events: $error")),
                data: (events) {
                  if (events.isEmpty) {
                    return Center(
                      child: Text(
                        "No events available for this schedule",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenSize.textScaler
                              .scale(14), // Responsive font size
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: events.map((event) {
                      return Card(
                        color: const Color.fromARGB(136, 252, 33, 33),
                        margin: EdgeInsets.symmetric(
                            vertical:
                                ScreenSize.height * 0.01), // Responsive margin
                        child: Padding(
                          padding: EdgeInsets.all(
                              ScreenSize.width * 0.04), // Responsive padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ** Event Image **
                              if (event.image.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenSize.width *
                                          0.02), // Responsive border radius
                                  child: Image.network(
                                    event.image,
                                    height: ScreenSize.height *
                                        0.2, // Responsive height
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/placeholder.png',
                                        height: ScreenSize.height *
                                            0.2, // Responsive height
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              SizedBox(
                                  height: ScreenSize.height *
                                      0.01), // Responsive spacing

                              // ** Event Title **
                              Text(
                                event.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenSize.textScaler
                                      .scale(16), // Responsive font size
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
                              SizedBox(
                                  height: ScreenSize.height *
                                      0.01), // Responsive spacing

                              // ** Event Description with "Read More" Button **
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: event.description.length > 100
                                              ? "${event.description.substring(0, 100)}..."
                                              : event.description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: ScreenSize.textScaler
                                                    .scale(
                                                        14), // Responsive font size
                                              ),
                                        ),
                                        if (event.description.length > 100)
                                          WidgetSpan(
                                            child: InkWell(
                                              onTap: () {
                                                // Navigate to Event Details Screen
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EventDetailsPage(
                                                            event: event),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                " Read More",
                                                style: TextStyle(
                                                  color:
                                                      AppColors.secondaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ScreenSize
                                                      .textScaler
                                                      .scale(
                                                          14), // Responsive font size
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              ),
                              SizedBox(
                                  height: ScreenSize.height *
                                      0.01), // Responsive spacing

                              // ** Event Date & Time **
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: ScreenSize.width *
                                          0.04, // Responsive icon size
                                      color: Colors.white),
                                  SizedBox(
                                      width: ScreenSize.width *
                                          0.02), // Responsive spacing
                                  Text(
                                    "${event.eventDate} at ${event.eventTime}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: ScreenSize.textScaler.scale(
                                              14), // Responsive font size
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: ScreenSize.height *
                                      0.01), // Responsive spacing

                              // ** Event Location **
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: ScreenSize.width *
                                          0.04, // Responsive icon size
                                      color: Colors.white),
                                  SizedBox(
                                      width: ScreenSize.width *
                                          0.02), // Responsive spacing
                                  Text(
                                    event.location,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: ScreenSize.textScaler.scale(
                                              14), // Responsive font size
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
