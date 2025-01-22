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
          backgroundColor: const Color.fromARGB(198, 243, 18, 18),
          title: const Text(
            "Monday Marks",
            style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w500),
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
