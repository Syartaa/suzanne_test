import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/provider/locale_provider.dart';
import 'package:suzanne_podcast_app/screens/onboarding/choose_interest_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          // Logo
          Center(
            child: ClipRRect(
              child: Image(
                image: AssetImage("assets/logo/logo2.png"),
                width: 170 * ScreenSize.width / 375, // Scaled width
              ),
            ),
          ),
          SizedBox(height: 30 * ScreenSize.height / 800), // Scaled height
          // Title Text
          Text(
            AppLocalizations.of(context)!.selectLanguage,
            style: TextStyle(
              fontSize: 20 * ScreenSize.textScaler.scale(1), // Scaled font size
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16 * ScreenSize.height / 800), // Scaled height
          // Subtitle Text
          Text(
            AppLocalizations.of(context)!.change_language,
            style: TextStyle(
              fontSize: 14 * ScreenSize.textScaler.scale(1), // Scaled font size
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30 * ScreenSize.height / 800), // Scaled height
          // Language Buttons
          _buildLanguageButton(context, ref,
              languageCode: 'en', languageName: 'English'),
          SizedBox(height: 16 * ScreenSize.height / 800), // Scaled height
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
        padding: EdgeInsets.symmetric(
          vertical: 14 * ScreenSize.height / 800, // Scaled padding
          horizontal: 32 * ScreenSize.width / 375, // Scaled padding
        ),
      ),
      child: Text(
        languageName,
        style: TextStyle(
          fontSize: 18 * ScreenSize.textScaler.scale(1), // Scaled font size
          fontWeight: FontWeight.w600,
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
