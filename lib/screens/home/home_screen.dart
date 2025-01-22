// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:suzanne_podcast_app/provider/schedules_provider.dart';
import 'package:suzanne_podcast_app/screens/home/widget/featured_podcast.dart';
import 'package:suzanne_podcast_app/screens/home/widget/scheculed_slider.dart';
import 'package:suzanne_podcast_app/screens/home/widget/upcomming.dart';
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
        actions: [
          IconButton(
            onPressed: () {},
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
                  image: AssetImage("assets/images/banner2.png"),
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
              FeaturedPodcastsWidget(),
              SizedBox(
                height: 35,
              ),
              UpcomingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
