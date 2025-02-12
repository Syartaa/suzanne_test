// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:suzanne_podcast_app/constants/podcast_slider_widget.dart';
import 'package:suzanne_podcast_app/provider/podcast_provider.dart';
import 'package:suzanne_podcast_app/provider/schedules_provider.dart';
import 'package:suzanne_podcast_app/screens/home/widget/scheculed_slider.dart';
import 'package:suzanne_podcast_app/screens/home/widget/tab_event_podcast.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_screen.dart';
import 'package:suzanne_podcast_app/screens/profile/profile_screen.dart';
import 'package:suzanne_podcast_app/screens/schedules/monday_marks_screen.dart';
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
    // Delay the loadSchedules call until the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(schedulesNotifierProvider.notifier).loadSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final podcastsAsyncValue = ref.watch(podcastProvider);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Center(
          child: Image(
            image: AssetImage("assets/logo/logo2.png"),
            width: 100,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the back icon color to white
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ProfileScreen()));
            },
            icon: Icon(
              Iconsax.profile_circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image(
                  image: AssetImage("assets/images/banner.jpg"),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              // Monday Marks Section
              ScheculedSlider(
                title: "Monday Marks",
                onSeeMorePressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => MondayMarksScreen()));
                },
              ),
              SizedBox(
                height: 35,
              ),
              PodcastSliderWidget(
                title: "Featured Podcasts",
                seeMoreText: "See more",
                routeBuilder: (ctx) => PodcastScreen(),
                podcastsAsyncValue: podcastsAsyncValue,
              ),
              SizedBox(
                height: 20,
              ),

              PodcastsEventsTab(),
            ],
          ),
        ),
      ),
    );
  }
}
