class ReviewWriteRequest {
  final String userId;
  final String title;
  final String contents;
  final double rating;

  ReviewWriteRequest({
    required this.userId,
    required this.title,
    required this.contents,
    required this.rating,
  });
}
