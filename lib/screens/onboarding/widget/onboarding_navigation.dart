import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/onboarding_provider.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';

class OnBoardingNavigation extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingStateProvider);

    return Positioned(
      bottom: ScreenSize.height * 0.05, // Responsive bottom position
      left: ScreenSize.width * 0.05, // Responsive left position
      child: Row(
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () => ref
                .read(onboardingStateProvider.notifier)
                .dotNavigationClick(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(
                horizontal: ScreenSize.width * 0.01, // Responsive margin
              ),
              height: ScreenSize.height * 0.01, // Responsive height
              width: onboardingState.currentPageIndex == index
                  ? ScreenSize.width * 0.06 // Responsive width for active dot
                  : ScreenSize.width *
                      0.03, // Responsive width for inactive dot
              decoration: BoxDecoration(
                color: onboardingState.currentPageIndex == index
                    ? const Color(0xFFFC2221)
                    : Colors.grey,
                borderRadius: BorderRadius.circular(
                  ScreenSize.width * 0.015, // Responsive border radius
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
