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
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var image in images) {
      precacheImage(AssetImage(image), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(onboardingStateProvider.notifier);

    return Scaffold(
      backgroundColor: Color(0xFFFC2221),
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.updatePageIndicator(index);
              if (index + 1 < images.length) {
                precacheImage(AssetImage(images[index + 1]), context);
              }
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              final titles = [
                'Tune in to the Suzanne Podcast',
                'Curated Events Beyond Mainstream. Just for You',
              ];

              final highlightedTexts = [
                'Suzanne',
                'Just for You',
              ];

              final subtitles = [
                'A podcast made in Prishtina telling the untold stories of women of Kosova and neighbourhoods they lived',
                'Bringing you the daily recommendations and review of the best arts, culture, food, fashion from Kosova and beyond...',
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
              onPressed: () => controller.skipPage(context),
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
