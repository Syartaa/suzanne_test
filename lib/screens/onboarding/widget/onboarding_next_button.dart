import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/onboarding_provider.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';

class OnBoardingNextButton extends ConsumerWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingStateProvider);
    final controller = ref.read(onboardingStateProvider.notifier);

    return Align(
      alignment: const Alignment(0, 0.9),
      child: ElevatedButton(
        onPressed: () {
          controller.nextPage(context); // ✅ Pass context here
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal:
                25 * ScreenSize.width / 375, // Scaled horizontal padding
            vertical: 12 * ScreenSize.height / 800, // Scaled vertical padding
          ),
        ),
        child: Text(
          onboardingState.currentPageIndex == 2 ? 'Get Started' : 'Next',
          style: TextStyle(
            color: Color(0xFF373636),
            fontSize: 20 * ScreenSize.textScaler.scale(1), // Scaled font size
          ),
        ),
      ),
    );
  }
}
