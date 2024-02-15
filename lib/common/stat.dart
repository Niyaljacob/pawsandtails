import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int filledStars;
  final int halfFilledStars;
  final int totalStars;
  final double starSize;
  final Color starColor;

  const StarRating({
    Key? key,
    required this.filledStars,
    required this.halfFilledStars,
    required this.totalStars,
    this.starSize = 20,
    this.starColor = Colors.yellow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    // Add filled stars
    for (int i = 0; i < filledStars; i++) {
      stars.add(Icon(
        Icons.star,
        size: starSize,
        color: starColor,
      ));
    }

    // Add half-filled star
    if (halfFilledStars == 1) {
      stars.add(Icon(
        Icons.star_half,
        size: starSize,
        color: starColor,
      ));
    }

    // Add remaining empty stars
    int remainingStars = totalStars - filledStars - halfFilledStars;
    for (int i = 0; i < remainingStars; i++) {
      stars.add(Icon(
        Icons.star_border,
        size: starSize,
        color: starColor,
      ));
    }

    return Row(
      children: stars,
    );
  }
}
