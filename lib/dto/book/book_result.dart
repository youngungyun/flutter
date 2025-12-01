class BookResult {
  final List<BookResponse> books;
  final Metadata metadata;

  BookResult({required this.books, required this.metadata});
}

/// 카카오 API 응답의 본문
/// isbn은 isbn13이 없을 경우에만 isbn10 사용
class BookResponse {
  final String title;
  final List<String> authors;
  final List<String> translators;
  final String publisher;
  final String isbn;
  final DateTime publishDate;
  final String thumbnailUrl;
  const BookResponse({
    required this.title,
    required this.authors,
    required this.translators,
    required this.publisher,
    required this.isbn,
    required this.publishDate,
    required this.thumbnailUrl,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      title: json['title'],
      authors: json['authors'].cast<String>(),
      translators: json['translators'].cast<String>(),
      publisher: json['publisher'],
      thumbnailUrl: json['thumbnail'],
      publishDate: DateTime.parse(json['datetime']),
      isbn: (json['isbn'] as String).split(' ').last,
    );
  }
}

/// 카카오 API 응답의 메타 데이터 부분
class Metadata {
  final int totalCount;
  final int pageableCount;
  final bool isEnd;

  const Metadata({
    required this.totalCount,
    required this.pageableCount,
    required this.isEnd,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      totalCount: json['total_count'],
      pageableCount: json['pageable_count'],
      isEnd: json['is_end'],
    );
  }
}
