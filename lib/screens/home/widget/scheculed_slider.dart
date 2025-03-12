import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/provider/schedules_provider.dart';
import 'package:suzanne_podcast_app/screens/schedules/schedule_details_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class ScheduledSlider extends ConsumerWidget {
  final String title;
  final VoidCallback onSeeMorePressed;
  final double sliderHeight;

  const ScheduledSlider({
    super.key,
    required this.title,
    required this.onSeeMorePressed,
    this.sliderHeight = 200.0,
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
                fontSize:
                    ScreenSize.textScaler.scale(24), // ✅ Proper text scaling
                color: const Color(0xFFFFF8F0),
                shadows: const [
                  Shadow(
                    color: Color(0xFFFFF1F1),
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onSeeMorePressed,
              child: Text(
                AppLocalizations.of(context)!.seeMore,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: ScreenSize.textScaler
                          .scale(14), // ✅ Proper text scaling
                      color: AppColors.secondaryColor,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenSize.height * 0.01), // ✅ Responsive height

        schedulesState.when(
          data: (schedules) => SizedBox(
            height: sliderHeight, // ✅ No need to scale height directly
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ScheduleDetailsScreen(schedule: schedule),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: ScreenSize.width * 0.04), // ✅ Scaled padding
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: schedule.images,
                        width: ScreenSize.width * 0.8, // ✅ Responsive width
                        height: sliderHeight, // ✅ Keeps height constant
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
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
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                    right: ScreenSize.width * 0.04), // ✅ Scaled padding
                child: Shimmer.fromColors(
                  baseColor: AppColors.primaryColor,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: ScreenSize.width * 0.8, // ✅ Responsive width
                    height: sliderHeight, // ✅ Consistent height
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
              style: TextStyle(
                color: Colors.red,
                fontSize:
                    ScreenSize.textScaler.scale(16), // ✅ Proper text scaling
              ),
            ),
          ),
        ),
      ],
    );
  }
}
