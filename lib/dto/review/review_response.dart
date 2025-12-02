class ReviewResponse {
  final String reviewId;
  final String bookId;
  final String writer;
  final String title;
  final String contents;
  final double rating;
  final DateTime createdAt;

  ReviewResponse({
    required this.reviewId,
    required this.bookId,
    required this.writer,
    required this.title,
    required this.contents,
    required this.rating,
    required this.createdAt,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      reviewId: json['review_id'],
      bookId: json['book_id'],
      writer: json['profile']['nickname'],
      title: json['title'],
      contents: json['contents'],
      rating: (json['rating'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
