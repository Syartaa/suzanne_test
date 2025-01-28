import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/screens/live/scheduled_live_events.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Center(
          child: Text(
            "Live",
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
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => ScheduledLiveEvents()));
                        },
                        child: Text(
                          "Scheduled Live Events",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        )),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          "Ongoing Live Podcasts",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
