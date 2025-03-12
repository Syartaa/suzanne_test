import 'package:flutter/material.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';

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
      padding: EdgeInsets.all(10 * ScreenSize.width / 375), // Scaled padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image with fade-in animation
          Image(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.4,
            image: AssetImage(image),
            fit: BoxFit.contain,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 500),
                child: child,
              );
            },
          ),
          SizedBox(height: 20 * ScreenSize.height / 800), // Scaled spacing
          // Title with highlighted text, split into two parts
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: firstPart + '\n', // First part and add line break
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 28 *
                            ScreenSize.textScaler.scale(1), // Scaled font size
                      ),
                ),
                TextSpan(
                  text: highlightedText,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color:
                            const Color(0xFF373636), // Highlighted text color
                        fontWeight: FontWeight.w700,
                        fontSize: 28 *
                            ScreenSize.textScaler.scale(1), // Scaled font size
                      ),
                ),
                TextSpan(
                  text: secondPart,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 27 *
                            ScreenSize.textScaler.scale(1), // Scaled font size
                      ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 25 * ScreenSize.height / 800), // Scaled spacing
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
