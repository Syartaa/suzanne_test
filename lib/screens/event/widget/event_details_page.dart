import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/models/events.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;
  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Text(
          "Event",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: ScreenSize.textScaler.scale(24), // Scaled font size
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
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the back icon color to white
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.all(16.0 * ScreenSize.width / 375), // Scaled padding
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(image: NetworkImage(event.image)),
              ),
              SizedBox(
                height: 20 * ScreenSize.height / 800, // Scaled height
              ),
              Text(
                event.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenSize.textScaler.scale(20), // Scaled font size
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
              Text(
                event.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize:
                        ScreenSize.textScaler.scale(16), // Scaled font size
                    color: Colors.white70),
              ),
              const SizedBox(height: 16.0),

              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16 * ScreenSize.width / 375, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    "${event.eventDate} at ${event.eventTime}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize:
                            ScreenSize.textScaler.scale(16), // Scaled font size
                        color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              // ** Event Location **
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16 * ScreenSize.width / 375, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    event.location,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize:
                            ScreenSize.textScaler.scale(16), // Scaled font size
                        color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
