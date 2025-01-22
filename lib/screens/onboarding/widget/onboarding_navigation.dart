import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/onboarding_provider.dart';

class OnBoardingNavigation extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(OnboardingStateProvider);

    return Positioned(
      bottom: 40,
      left: 20,
      child: Row(
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () => ref
                .read(OnboardingStateProvider.notifier)
                .dotNavigationClick(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 10,
              width: onboardingState.currentPageIndex == index ? 20 : 10,
              decoration: BoxDecoration(
                color: onboardingState.currentPageIndex == index
                    ? Color(0xFFFC2221)
                    : Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          );
        }),
      ),
    );
  }
}
