import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/screens/schedules/widget/monday_marks_list.dart';
import 'package:suzanne_podcast_app/screens/schedules/widget/mondays_slider.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class MondayMarksScreen extends StatelessWidget {
  const MondayMarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(198, 243, 18, 18),
          title: Text(
            "Monday Marks",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: ScreenSize.width *
                  0.06, // Dynamic font size based on screen width
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
                ScreenSize.width * 0.04), // Dynamic padding based on width
            child: Column(
              children: [
                // Monday Slider
                Padding(
                  padding: EdgeInsets.all(
                      ScreenSize.width * 0.02), // Dynamic padding for slider
                  child: MondaysSlider(),
                ),
                MondayMarksList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
