import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suzanne_podcast_app/provider/schedules_provider.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class ScheculedSlider extends ConsumerWidget {
  final String title;
  final VoidCallback onSeeMorePressed;
  final double sliderHeight;

  const ScheculedSlider({
    super.key,
    required this.title,
    required this.onSeeMorePressed,
    this.sliderHeight = 200.0, // Default slider height
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesState = ref.watch(schedulesNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
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
            TextButton(
              onPressed: onSeeMorePressed,
              child: Text(
                "See more",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondaryColor,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        schedulesState.when(
          data: (schedules) => SizedBox(
            height: sliderHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: CachedNetworkImage(
                      imageUrl: schedule.images,
                      width: 300,
                      height: sliderHeight,
                      fit: BoxFit.cover,
                      // placeholder: (context, url) => Center(
                      //   child: CircularProgressIndicator(),
                      // ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                );
              },
            ),
          ),
          loading: () => SizedBox(
            height: sliderHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // Show 3 placeholder items
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Shimmer.fromColors(
                  baseColor: AppColors.primaryColor,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 300,
                    height: sliderHeight,
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
