import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/provider/ratings_provider.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';

class RatingCommentsWidget extends ConsumerStatefulWidget {
  final String podcastId;

  const RatingCommentsWidget({super.key, required this.podcastId});

  @override
  ConsumerState<RatingCommentsWidget> createState() =>
      _RatingCommentsWidgetState();
}

class _RatingCommentsWidgetState extends ConsumerState<RatingCommentsWidget> {
  int selectedRating = 0;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ratingsNotifier = ref.read(podcastRatingsProvider.notifier);

    return Container(
      // padding:
      //     EdgeInsets.all(ScreenSize.width > 600 ? 24 : 16), // Adjust padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Star Rating Section
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.yellow,
                  size: ScreenSize.width > 600 ? 40 : 30, // Adjust star size
                ),
                onPressed: () {
                  setState(() => selectedRating = index + 1);
                },
              );
            }),
          ),
          const SizedBox(height: 10),

          // Text Field with Send Button
          TextField(
            controller: commentController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 245, 49, 49),
              hintText: "Leave a comment...",
              hintStyle: TextStyle(
                color: const Color(0xFFFF8F80),
                fontSize: ScreenSize.width > 600 ? 18 : 15, // Adjust font size
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  if (selectedRating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Please select a rating before submitting"),
                      ),
                    );
                    return;
                  }
                  ratingsNotifier.ratePodcast(
                    podcastId: widget.podcastId,
                    rate: selectedRating,
                    comment: commentController.text.isNotEmpty
                        ? commentController.text
                        : null,
                  );
                  commentController.clear();
                  setState(() => selectedRating = 0);
                },
                icon: const Icon(Icons.send, color: Colors.white),
                tooltip: "Submit Comment",
              ),
            ),
            minLines: 3, // Minimum height like a textarea
            maxLines: null, // Expands as needed
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }
}
