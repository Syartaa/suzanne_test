import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:suzanne_podcast_app/provider/banner_provider.dart'; // Import the banner provider

class BannerWidget extends ConsumerWidget {
  final String bannerType;

  const BannerWidget({Key? key, required this.bannerType}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerAsyncValue = ref.watch(bannerProvider);

    return bannerAsyncValue.when(
      data: (banners) {
        final banner = banners.firstWhere(
          (banner) => banner.type == bannerType,
        );

        return banner != null
            ? GestureDetector(
                onTap: () {
                  // If there's a link, open it
                  if (banner.bannerLink != null) {
                    _launchURL(banner.bannerLink!);
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    banner.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Center(child: Text("No $bannerType banner available"));
      },
      loading: () => Center(
          child: CircularProgressIndicator(
        color: AppColors.secondaryColor,
      )),
      error: (error, stackTrace) => Center(child: Text("Error: $error")),
    );
  }

  // Function to launch URL in the browser
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // Convert string URL to Uri

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // Opens the URL in the default browser
    } else {
      throw 'Could not launch $url';
    }
  }
}
