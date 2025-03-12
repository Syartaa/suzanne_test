import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/screens/onboarding/welcome_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class ChooseInterestScreen extends StatefulWidget {
  const ChooseInterestScreen({super.key});

  @override
  _ChooseInterestScreenState createState() => _ChooseInterestScreenState();
}

class _ChooseInterestScreenState extends State<ChooseInterestScreen> {
  // List to track selected interests
  final List<String> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      print(
          "🚨 Localization is null. Make sure localization is properly set up.");
      return const SizedBox.shrink();
    }

    print("📝 Localization Loaded: ${loc?.chooseInterests ?? 'NULL'}");

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(
          ScreenSize.width * 0.05, // Responsive padding
        ),
        child: Column(
          children: [
            SizedBox(height: ScreenSize.height * 0.05), // Responsive spacing
            Center(
              child: ClipRRect(
                child: Image(
                  image: const AssetImage("assets/logo/logo2.png"),
                  width: ScreenSize.width * 0.4, // Responsive width
                ),
              ),
            ),
            SizedBox(height: ScreenSize.height * 0.04), // Responsive spacing
            Text(
              loc.chooseInterests,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize:
                    ScreenSize.textScaler.scale(17), // Responsive font size
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: ScreenSize.height * 0.02), // Responsive spacing
            Text(
              loc.dontWorryChangeLater,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: const Color.fromARGB(186, 252, 252, 252),
                fontSize:
                    ScreenSize.textScaler.scale(13), // Responsive font size
              ),
            ),
            SizedBox(height: ScreenSize.height * 0.04), // Responsive spacing
            // Interest Buttons
            Wrap(
              spacing: ScreenSize.width * 0.04, // Responsive spacing
              runSpacing: ScreenSize.width * 0.04, // Responsive spacing
              alignment: WrapAlignment.center,
              children: [
                _buildInterestButton(loc.music),
                _buildInterestButton(loc.podcasts),
                _buildInterestButton(loc.cinema),
                _buildInterestButton(loc.books),
                _buildInterestButton(loc.theatre),
                _buildInterestButton(loc.clubbing),
                _buildInterestButton(loc.literature),
                _buildInterestButton(loc.visualArts),
              ],
            ),
            const Spacer(),
            // Skip and Continue Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(context, loc.skip, AppColors.secondaryColor,
                    const Color.fromARGB(255, 0, 0, 0)),
                _buildActionButton(
                    context,
                    loc.continueButton,
                    const Color.fromARGB(255, 202, 13, 13),
                    AppColors.secondaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create interest buttons
  Widget _buildInterestButton(String text) {
    final isSelected = _selectedInterests.contains(text);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedInterests.remove(text);
          } else {
            _selectedInterests.add(text);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.width * 0.05, // Responsive padding
          vertical: ScreenSize.height * 0.015, // Responsive padding
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(
            ScreenSize.width * 0.05, // Responsive border radius
          ),
          border: Border.all(
            color: AppColors.secondaryColor,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                isSelected ? AppColors.primaryColor : AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: ScreenSize.textScaler.scale(14), // Responsive font size
          ),
        ),
      ),
    );
  }

  // Helper function to create action buttons
  Widget _buildActionButton(
    BuildContext context,
    String text,
    Color bgColor,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => WelcomeScreen()));
      },
      child: Container(
        width: ScreenSize.width * 0.35, // Responsive width
        height: ScreenSize.height * 0.07, // Responsive height
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(
            ScreenSize.width * 0.06, // Responsive border radius
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: ScreenSize.textScaler.scale(16), // Responsive font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
