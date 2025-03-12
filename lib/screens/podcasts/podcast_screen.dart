import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/constants/banner_widget.dart';
import 'package:suzanne_podcast_app/constants/podcast_slider_widget.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/widget/costum_tab_bar.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class PodcastScreen extends ConsumerWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcastsAsyncValue = ref.watch(podcastProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        centerTitle: true, // Centers the title horizontally
        title: Text(
          "Podcasts",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 24 * ScreenSize.textScaler.scale(1), // Scaled font size
            color: const Color(0xFFFFF8F0),
            shadows: [
              Shadow(
                color:
                    const Color(0xFFFFF1F1), // Drop shadow color (light pink)
                offset: const Offset(1.0, 1.0), // Shadow position
                blurRadius: 3.0, // Blur effect for the shadow
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the back icon color to white
        ),
      ),
      body: DefaultTabController(
        length: 3, // Number of tabs
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.all(15.0 * ScreenSize.width / 375), // Scaled padding
            child: Column(
              children: [
                BannerWidget(bannerType: 'main'),
                SizedBox(
                  height: 35 * ScreenSize.height / 800, // Scaled spacing
                ),
                PodcastSliderWidget(
                  title: "Most Popular",
                  seeMoreText: "",
                  routeBuilder: (ctx) => const PodcastScreen(),
                  podcastsAsyncValue: podcastsAsyncValue,
                ),
                const SizedBox(height: 20),
                const CustomTabBarWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
