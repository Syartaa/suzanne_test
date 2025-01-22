import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/screens/podcasts/widget/costum_tab_bar.dart';
import 'package:suzanne_podcast_app/screens/podcasts/widget/popular_podcast.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Text(
          "Podcasts",
          style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: DefaultTabController(
        length: 3, // Number of tabs
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image(
                    image: AssetImage("assets/images/banner3.png"),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                PopularPodcastsWidget(),
                // Add some space before the TabBar
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
