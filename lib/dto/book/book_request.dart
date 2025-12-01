import 'package:rebook/services/book_service.dart';

class BookRequest {
  final String query;
  final SortType sortType;
  final int page;
  final int size;
  final SearchType searchType;

  const BookRequest({
    required this.query,
    required this.sortType,
    required this.page,
    required this.size,
    required this.searchType,
  });
}
