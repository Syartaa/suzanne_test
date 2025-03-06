import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/screens/onboarding/welcome_screen.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 50),
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
              loc.chooseInterests,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              loc.dontWorryChangeLater,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color.fromARGB(186, 252, 252, 252),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 30),
            // Interest Buttons
            Wrap(
              spacing: 15.0,
              runSpacing: 15.0,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
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
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
