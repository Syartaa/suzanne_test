// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/onboarding_provider.dart';
import 'package:suzanne_podcast_app/screens/onboarding/widget/onboarding_next_button.dart';
import 'package:suzanne_podcast_app/screens/onboarding/widget/onboarding_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final List<String> images = [
    'assets/onboarding/1.png',
    'assets/onboarding/3.png',
    'assets/onboarding/2.png',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Preload all onboarding images
    for (var image in images) {
      precacheImage(AssetImage(image), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(OnboardingStateProvider.notifier);

    return Scaffold(
      backgroundColor: Color(0xFFFC2221),
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.updatePageIndicator(index);

              // Lazy preload the next image
              if (index + 1 < images.length) {
                precacheImage(AssetImage(images[index + 1]), context);
              }
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              final titles = [
                'Tune into the Suzanne Podcast',
                'Curated Events Just for You',
                'Discover, engage, and Empower',
              ];

              final highlightedTexts = [
                'Suzanne',
                'Just for You',
                'Empower',
              ];

              final subtitles = [
                'Stories, discussions, and empowerment for women everywhere.',
                'Find and attend the best events in your region.',
                'Your go-to platform for local events, podcasts, and creative industries.',
              ];

              return OnBoardingPage(
                image: images[index],
                title: titles[index],
                highlightedText: highlightedTexts[index],
                subTitle: subtitles[index],
              );
            },
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
