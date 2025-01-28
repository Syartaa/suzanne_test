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
        centerTitle: true, // Centers the title horizontally
        title: Text(
          "Podcasts",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
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
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the back icon color to white
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
                    image: AssetImage("assets/images/banner.jpg"),
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
