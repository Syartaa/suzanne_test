import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suzanne_podcast_app/provider/schedules_provider.dart';
import 'package:suzanne_podcast_app/screens/schedules/schedule_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class MondayMarksList extends ConsumerWidget {
  const MondayMarksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesState = ref.watch(schedulesNotifierProvider);

    return schedulesState.when(
      data: (schedules) => ListView.builder(
        shrinkWrap: true, // Allows ListView to size itself based on content
        physics:
            NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical:
                    ScreenSize.height * 0.02), // Responsive vertical padding
            child: Card(
              color: const Color.fromARGB(186, 252, 33, 33),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                    ScreenSize.width * 0.04), // Responsive padding
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: schedule.images,
                        width: ScreenSize.width *
                            0.2, // Responsive width for image
                        height: ScreenSize.width *
                            0.2, // Responsive height for image
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.broken_image,
                          size: 80,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: ScreenSize.width *
                            0.03), // Responsive spacing between image and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.title,
                            style: TextStyle(
                              fontSize: ScreenSize.width *
                                  0.04, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(221, 255, 255, 255),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScheduleDetailsScreen(schedule: schedule),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_circle_right,
                        color: AppColors.secondaryColor,
                        size: ScreenSize.width * 0.07, // Responsive icon size
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      loading: () => ListView.builder(
        itemCount: 6, // Number of shimmer placeholders
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical:
                    ScreenSize.height * 0.02), // Responsive vertical padding
            child: Card(
              color: Colors.grey[300],
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                    ScreenSize.width * 0.04), // Responsive padding
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Shimmer for the image
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: ScreenSize.width *
                            0.2, // Responsive width for image
                        height: ScreenSize.width *
                            0.2, // Responsive height for image
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: ScreenSize.width * 0.03), // Responsive spacing
                    // Shimmer for text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: ScreenSize.height *
                                  0.02, // Responsive height for text
                              color: Colors.grey[300],
                              width: double.infinity,
                            ),
                          ),
                          SizedBox(
                              height: ScreenSize.height *
                                  0.01), // Responsive spacing
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: ScreenSize.height *
                                  0.018, // Responsive height for text
                              color: Colors.grey[300],
                              width: ScreenSize.width *
                                  0.4, // Responsive width for text
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Shimmer for the button
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Icon(
                        Icons.arrow_circle_right,
                        color: Colors.grey[300],
                        size: ScreenSize.width * 0.07, // Responsive icon size
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error: ${error.toString()}',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
