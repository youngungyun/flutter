import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:rebook/dto/review/review_response.dart';

class ReviewCard extends StatelessWidget {
  final ReviewResponse review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        elevation: 8.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    review.writer,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Text(
                          "${review.rating} / 5.0",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      RatingBar.builder(
                        itemBuilder: (_, __) {
                          return Icon(Icons.star, color: Colors.amber);
                        },
                        onRatingUpdate: (_) {},
                        ignoreGestures: true,
                        allowHalfRating: true,
                        itemCount: 5,
                        minRating: 1.0,
                        maxRating: 5.0,
                        initialRating: review.rating,
                        itemSize: 26.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(review.title, style: TextStyle(fontSize: 24.0)),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0),
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(review.createdAt),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                top: 8.0,
                bottom: 10.0,
              ),
              child: Text(review.contents, style: TextStyle(fontSize: 14.0)),
            ),
          ],
        ),
      ),
    );
  }
}
