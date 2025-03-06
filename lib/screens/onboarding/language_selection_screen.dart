import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/provider/locale_provider.dart';

import 'package:suzanne_podcast_app/screens/onboarding/choose_interest_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart'; // Import ChooseInterestScreen

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(localeProvider.notifier).setLocale('en');
                _navigateToNextScreen(context);
              },
              child: Text("English"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(localeProvider.notifier).setLocale('sq');
                _navigateToNextScreen(context);
              },
              child: Text("Shqip"),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => ChooseInterestScreen()),
    );
  }
}
