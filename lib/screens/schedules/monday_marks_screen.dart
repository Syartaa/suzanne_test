// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/screens/schedules/widget/monday_marks_list.dart';
import 'package:suzanne_podcast_app/screens/schedules/widget/mondays_slider.dart';
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                // Monday Slider
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
