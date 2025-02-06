import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/screens/home/widget/evet_tab.dart';
import 'package:suzanne_podcast_app/screens/home/widget/upcomming.dart';
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
        SizedBox(height: 15),
        SizedBox(
          height: 300, // Adjust height as needed
          child: TabBarView(
            controller: _tabController,
            children: [
              Center(child: PodcastTab()),
              Center(child: EventTab()),
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
