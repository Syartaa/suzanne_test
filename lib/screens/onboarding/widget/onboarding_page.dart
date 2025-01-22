import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.highlightedText,
    required this.subTitle,
  });

  final String image, title, highlightedText, subTitle;

  @override
  Widget build(BuildContext context) {
    // Split the title into two parts, where you want a new line after "Tune into the"
    String firstPart = title.split(highlightedText)[0]; // "Tune into the "
    String secondPart = title.split(highlightedText)[1]; // "Suzanne Podcast"

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.4,
            image: AssetImage(image),
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          // Title with highlighted text, split into two parts
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: firstPart + '\n', // First part and add line break
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 28 // Non-highlighted text color
                      ),
                ),
                TextSpan(
                  text: highlightedText,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF373636), // Highlighted text color
                      fontWeight: FontWeight.w700,
                      fontSize: 28),
                ),
                TextSpan(
                  text: secondPart,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 27 // Non-highlighted text color
                      ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          // Subtitle
          Text(
            subTitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
