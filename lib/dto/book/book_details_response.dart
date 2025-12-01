class BookDetailsResponse {
  final String title;
  final String content;
  final List<String> authors;
  final List<String> translators;
  final String? isbn10;
  final String? isbn13;
  final String publisher;
  final DateTime? publishDate;
  final String? thumbnailUrl;

  BookDetailsResponse({
    required this.title,
    required this.content,
    required this.authors,
    required this.translators,
    required this.publisher,
    this.isbn10,
    this.isbn13,
    this.publishDate,
    this.thumbnailUrl,
  });
}
