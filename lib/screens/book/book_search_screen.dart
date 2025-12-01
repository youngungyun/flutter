import 'package:flutter/material.dart';
import 'package:rebook/dto/book/book_request.dart';
import 'package:rebook/dto/book/book_result.dart';
import 'package:rebook/services/book_service.dart';
import 'package:rebook/widgets/book/book_card.dart';
import 'package:rebook/widgets/book/book_sort_type_selector.dart';
import 'package:rebook/widgets/book/search_type_selector.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';

class BookSearchScreen extends StatefulWidget {
  final BookService bookService = BookService.instance;
  BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  bool _isLoading = false;
  final int _size = 20;
  final _searchController = TextEditingController();
  int _page = 1;
  SearchType _searchType = SearchType.title;
  SortType _sortType = SortType.accurcy;
  List<BookResponse> _books = [];

  void onChangeSearchType(SearchType type) {
    setState(() {
      _searchType = type;
    });
  }

  void onChangeSortType(SortType type) {
    setState(() {
      _sortType = type;
    });
  }

  void onSearch() async {
    String query = _searchController.text;
    if (query.isEmpty) {
      return;
    }

    // 로딩 시작
    setState(() {
      _isLoading = true;
    });

    BookRequest request = BookRequest(
      query: query,
      sortType: _sortType,
      page: _page,
      size: _size,
      searchType: _searchType,
    );

    BookResult result = await widget.bookService.search(request);

    setState(() {
      _books = result.books;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "도서 검색"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchTypeSelector(onChange: onChangeSearchType),
          BookSortTypeSelector(onChange: onChangeSortType),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "검색어를 입력하세요.",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    "검색",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  // TODO: 스크롤 끝까지 내리면 다음 페이지 보여주기 구현
                  /*
                  1. 스크롤 끝에 도달하면 page 1 증가
                  2. 그 상태로 같은 쿼리 날리고 응답 받음
                  3. 받은 응답을 books의 끝에 추가
                  3-2. isEnd가 true면 더 이상 같이 없음. 스크롤 이벤트 끄고 마지막을 표시하는 위젯 넣음
                  */
                  /*
                  스크롤이 너무 길 때 최상단으로 이동시키는 버튼
                  FloatingActionButton으로 구현하기
                  */
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                    scrollDirection: Axis.vertical,
                    itemCount: _books.length,
                    itemBuilder: (context, index) =>
                        BookCard(book: _books[index]),
                  ),
                ),
        ],
      ),
    );
  }
}
