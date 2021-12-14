import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({required this.stars});
  final String? stars;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: double.parse(stars!),
      minRating: 1,
      ignoreGestures: true,
      allowHalfRating: true,
      itemSize: 22,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        debugPrint('$rating');
      },
    );
  }
}
