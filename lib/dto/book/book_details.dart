class BookDetails {
  final String title;
  final String contents;
  final List<String> authors;
  final List<String> translators;
  final String isbn;
  final String publisher;
  final DateTime datetime;
  final String thumbnail;
  final String? bookId;

  BookDetails({
    required this.title,
    required this.contents,
    required this.authors,
    required this.translators,
    required this.publisher,
    required this.isbn,
    required this.datetime,
    required this.thumbnail,
    this.bookId,
  });

  factory BookDetails.fromJson(Map<String, dynamic> json) {
    return BookDetails(
      title: json['title'],
      contents: json['contents'],
      authors: json['authors'].cast<String>(),
      translators: json['translators'].cast<String>(),
      publisher: json['publisher'],
      thumbnail: json['thumbnail'],
      datetime: DateTime.parse(json['datetime']),
      isbn: (json['isbn'] as String).split(' ').last,
      bookId: json['book_id'],
    );
  }
}
