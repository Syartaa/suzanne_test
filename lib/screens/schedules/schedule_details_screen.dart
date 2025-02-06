import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/models/schedule.dart';
import 'package:suzanne_podcast_app/provider/events_provider.dart';
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
            fontSize: 24,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ** Schedule Image **
              if (widget.schedule.images.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.schedule.images,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16.0),

              // ** Schedule Title **
              Text(
                widget.schedule.title,
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
              const SizedBox(height: 8.0),

              // ** Schedule Description **
              Text(widget.schedule.description,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16.0),

              // ** Events Section **
              Text(
                'Events:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),

              // ** Handle Loading, Data, and Error States **
              eventsState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Center(child: Text("Error loading events: $error")),
                data: (events) {
                  if (events.isEmpty) {
                    return const Center(
                      child: Text(
                        "No events available for this schedule",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Column(
                    children: events.map((event) {
                      return Card(
                        color: const Color.fromARGB(136, 252, 33, 33),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ** Event Image **
                              if (event.image.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    event.image,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/placeholder.png',
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 8.0),

                              // ** Event Title **
                              Text(
                                event.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
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
                              const SizedBox(height: 8.0),

                              // ** Event Description **
                              Text(
                                event.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8.0),

                              // ** Event Date & Time **
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 16, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${event.eventDate} at ${event.eventTime}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),

                              // ** Event Location **
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 16, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.location,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
