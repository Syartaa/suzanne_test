import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suzanne_podcast_app/provider/schedules_provider.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';

class MondaysSlider extends ConsumerWidget {
  const MondaysSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesState = ref.watch(schedulesNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 10),
        schedulesState.when(
          data: (schedules) => SizedBox(
            height:
                ScreenSize.height * 0.27, // Adjust height based on screen size
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return Padding(
                  padding: EdgeInsets.only(
                      right: ScreenSize.width * 0.02), // Responsive padding
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: CachedNetworkImage(
                      imageUrl: schedule.images,
                      width: ScreenSize.width * 0.87, // Responsive width
                      height: ScreenSize.height * 0.25, // Responsive height
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: ScreenSize.width *
                              0.89, // Responsive placeholder width
                          height: ScreenSize.height *
                              0.25, // Responsive placeholder height
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image,
                        size: 50,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          loading: () => SizedBox(
            height:
                ScreenSize.height * 0.25, // Adjust height based on screen size
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // Number of shimmer placeholders
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                    right: ScreenSize.width * 0.04), // Responsive padding
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width:
                        ScreenSize.width * 0.85, // Responsive placeholder width
                    height: ScreenSize.height *
                        0.25, // Responsive placeholder height
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Oops! Could not load schedules.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
