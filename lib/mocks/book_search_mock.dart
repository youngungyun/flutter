import 'package:rebook/dto/book/book_result.dart';

class BookSearchMock {
  static List<BookResponse> mocks = [
    BookResponse(
      title: '테스트1',
      authors: ['테스트1'],
      translators: ['테스트1'],
      isbn: '1234512345123',
      publisher: '출판사1',
      publishDate: DateTime(2025, 12, 25),
      thumbnailUrl:
          'https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038',
    ),
    BookResponse(
      title: '테스트2',
      authors: ['테스트1', '테스트2'],
      translators: ['테스트1', '테스트2'],
      isbn: '1234512345',
      publisher: '출판사2',
      publishDate: DateTime(2025, 12, 25),
      thumbnailUrl:
          'https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038',
    ),
    BookResponse(
      title: '테스트3',
      authors: ['테스트3'],
      translators: ['테스트3'],
      isbn: '1234512345123',
      publisher: '출판사3',

      publishDate: DateTime(2025, 12, 25),
      thumbnailUrl:
          'https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038',
    ),
    BookResponse(
      title: '테스트1',
      authors: ['테스트3', '테스트4'],
      translators: ['테스트3', '테스트4'],
      isbn: '1234512345',
      publisher: '출판사4',

      publishDate: DateTime(2025, 12, 25),
      thumbnailUrl:
          'https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038',
    ),
  ];
}
