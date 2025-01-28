import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/models/schedule.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class ScheduleDetailsScreen extends StatelessWidget {
  final Schedule schedule;

  const ScheduleDetailsScreen({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Text(
          schedule.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 24,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              if (schedule.images.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    schedule.images,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16.0),
              // Title Section
              Text(
                schedule.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFFFFF8F0),
                  shadows: [
                    Shadow(
                      color:
                          Color(0xFFFFF1F1), // Drop shadow color (light pink)
                      offset: Offset(1.0, 1.0), // Shadow position
                      blurRadius: 3.0, // Blur effect for the shadow
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              // Description Section
              Text(
                schedule.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),

              // Topics Section
              Text(
                'Topics:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              Column(
                children: schedule.topics.map((topic) {
                  return Card(
                    color: const Color.fromARGB(136, 252, 33, 33),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (topic.image != null && topic.image!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                topic.image!,
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
                          Text(
                            topic.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFFFFF8F0),
                              shadows: [
                                Shadow(
                                  color: Color(
                                      0xFFFFF1F1), // Drop shadow color (light pink)
                                  offset: Offset(1.0, 1.0), // Shadow position
                                  blurRadius: 3.0, // Blur effect for the shadow
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            topic.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8.0),
                          if (topic.link != null && topic.link!.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                debugPrint('Open link: ${topic.link}');
                              },
                              child: Text(
                                'View More',
                                style: const TextStyle(
                                  color: AppColors.secondaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
