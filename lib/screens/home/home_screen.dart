import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:suzanne_podcast_app/constants/banner_widget.dart';
import 'package:suzanne_podcast_app/constants/podcast_slider_widget.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/provider/notifications_provider.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/provider/schedules_provider.dart';
import 'package:suzanne_podcast_app/screens/home/widget/scheculed_slider.dart';
import 'package:suzanne_podcast_app/screens/home/widget/tab_event_podcast.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_screen.dart';
import 'package:suzanne_podcast_app/screens/profile/profile_screen.dart';
import 'package:suzanne_podcast_app/screens/schedules/monday_marks_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScreenSize.init(context);
      ref.read(schedulesNotifierProvider.notifier).loadSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final podcastsAsyncValue = ref.watch(podcastProvider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Center(
          child: Image(
            image: const AssetImage("assets/logo/logo2.png"),
            width: ScreenSize.width * 0.3,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                icon: const Icon(Iconsax.profile_circle, color: Colors.white),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final unreadCount = ref.watch(notificationsProvider).when(
                        data: (list) => list.where((n) => !n.isRead).length,
                        loading: () => 0,
                        error: (_, __) => 0,
                      );
                  return unreadCount > 0
                      ? Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor: Colors.red,
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(ScreenSize.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BannerWidget(bannerType: 'main'),
                SizedBox(height: ScreenSize.height * 0.05),
                ScheduledSlider(
                  title: loc.mondayMarks,
                  onSeeMorePressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MondayMarksScreen()));
                  },
                ),
                SizedBox(height: ScreenSize.height * 0.05),
                BannerWidget(bannerType: 'secondary'),
                SizedBox(height: ScreenSize.height * 0.03),
                PodcastSliderWidget(
                  title: loc.featuredPodcasts,
                  seeMoreText: loc.seeMore,
                  routeBuilder: (ctx) => PodcastScreen(),
                  podcastsAsyncValue: podcastsAsyncValue,
                ),
                //SizedBox(height: ScreenSize.height * 0.02),
                BannerWidget(bannerType: 'third'),
                SizedBox(height: ScreenSize.height * 0.03),
                PodcastsEventsTab(),
                SizedBox(height: ScreenSize.height * 0.07),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => _showInfoDialog(context),
              child: Container(
                padding: EdgeInsets.all(ScreenSize.width * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: ScreenSize.width * 0.07,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryColor,
          title: Text(AppLocalizations.of(context)!.infoTitle),
          content: Text(AppLocalizations.of(context)!.infoContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
