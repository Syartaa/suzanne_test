import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/provider/locale_provider.dart';
import 'package:suzanne_podcast_app/screens/onboarding/choose_interest_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor:
          AppColors.primaryColor, // Match the image background color
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: ClipRRect(
              child: Image(
                image: AssetImage("assets/logo/logo2.png"),
                width: 170,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.selectLanguage,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.change_language,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildLanguageButton(context, ref,
              languageCode: 'en', languageName: 'English'),
          const SizedBox(height: 16),
          _buildLanguageButton(context, ref,
              languageCode: 'sq', languageName: 'Shqip'),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, WidgetRef ref,
      {required String languageCode, required String languageName}) {
    return OutlinedButton(
      onPressed: () {
        ref.read(localeProvider.notifier).setLocale(languageCode);
        _navigateToNextScreen(context);
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
      ),
      child: Text(
        languageName,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
