import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/screens/onboarding/language_selection_screen.dart';

class OnboardingState {
  final int currentPageIndex;

  OnboardingState({this.currentPageIndex = 0});

  OnboardingState copyWith({int? currentPageIndex}) {
    return OnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}

class OnboardingStateNotifier extends StateNotifier<OnboardingState> {
  OnboardingStateNotifier() : super(OnboardingState());

  final PageController pageController = PageController();

  void updatePageIndicator(int index) {
    state = state.copyWith(currentPageIndex: index);
  }

  void dotNavigationClick(int index) {
    state = state.copyWith(currentPageIndex: index);
    pageController.jumpToPage(index);
  }

  void nextPage(BuildContext context) {
    if (state.currentPageIndex == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => LanguageSelectionScreen()),
      );
    } else {
      int nextPage = state.currentPageIndex + 1;
      state = state.copyWith(currentPageIndex: nextPage);
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => LanguageSelectionScreen()),
    );
  }
}

final onboardingStateProvider =
    StateNotifierProvider<OnboardingStateNotifier, OnboardingState>(
  (ref) => OnboardingStateNotifier(),
);
