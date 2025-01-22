// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/onboarding_provider.dart';
import 'package:suzanne_podcast_app/screens/onboarding/widget/onboarding_next_button.dart';
import 'package:suzanne_podcast_app/screens/onboarding/widget/onboarding_page.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(OnboardingStateProvider.notifier);

    return Scaffold(
      backgroundColor: Color(0xFFFC2221),
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              // Page 1: Highlight "Suzanne"
              OnBoardingPage(
                image: 'assets/onboarding/1.png',
                title: 'Tune into the Suzanne Podcast',
                highlightedText: 'Suzanne',
                subTitle:
                    'Stories, discussions, and empowerment for women everywhere.',
              ),
              // Page 2: Highlight "Just for You"
              OnBoardingPage(
                image: 'assets/onboarding/3.png',
                title: 'Curated Events Just for You',
                highlightedText: 'Just for You',
                subTitle: 'Find and attend the best events in your region.',
              ),
              // Page 3: Highlight "Empower"
              OnBoardingPage(
                image: 'assets/onboarding/2.png',
                title: 'Discover, engage, and Empower',
                highlightedText: 'Empower',
                subTitle:
                    'Your go-to platform for local events, podcasts and creative industries.',
              ),
            ],
          ),

          // Skip Button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () => controller.skipPage(),
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          // Centered Next Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
