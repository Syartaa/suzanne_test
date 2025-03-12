import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/screens/home/widget/evet_tab.dart';
import 'package:suzanne_podcast_app/screens/home/widget/podcast_tab.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class PodcastsEventsTab extends StatefulWidget {
  const PodcastsEventsTab({super.key});

  @override
  State<PodcastsEventsTab> createState() => _PodcastsEventsTabState();
}

class _PodcastsEventsTabState extends State<PodcastsEventsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.secondaryColor,
          tabs: [
            Tab(text: "Podcasts"),
            Tab(text: "Events"),
          ],
        ),
        SizedBox(height: ScreenSize.height * 0.02),
        SizedBox(
          height: ScreenSize.height * 0.5, // Adjust height dynamically
          child: TabBarView(
            controller: _tabController,
            children: [
              PodcastTab(),
              EventTab(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
