import 'package:flutter/material.dart';
import 'package:rebook/dto/book/book_request.dart';
import 'package:rebook/dto/book/book_result.dart';
import 'package:rebook/services/book_service.dart';
import 'package:rebook/utils/snackbar_util.dart';
import 'package:rebook/widgets/book/book_card.dart';
import 'package:rebook/widgets/book/book_sort_type_selector.dart';
import 'package:rebook/widgets/book/search_type_selector.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';
import 'package:rebook/widgets/common/scroll_floating_action.dart';

class BookSearchScreen extends StatefulWidget {
  final BookService bookService = BookService.instance;
  BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  bool _isEnd = false;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  final int _size = 20;
  final _searchController = TextEditingController();
  int _page = 1;
  SearchType _searchType = SearchType.title;
  SortType _sortType = SortType.accurcy;
  List<BookResponse> _books = [];

  /// 플로팅 버튼 생성 여부를 정하는 메서드
  void _onScroll() {
    bool shouldShow = _scrollController.offset >= 300;
    if (shouldShow != _showScrollToTop) {
      setState(() {
        _showScrollToTop = shouldShow;
      });
    }

    if (_isEnd) {
      return;
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      findMoreBooks();
    }
  }

  void onChangeSearchType(SearchType type) {
    setState(() {
      _searchType = type;
    });
  }

  /// 플로팅 액션을 눌렀을 때 스크롤을 최상단으로 올려주는 메서드
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(microseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  void onChangeSortType(SortType type) {
    setState(() {
      _sortType = type;
    });
  }

  void onSearch() async {
    setState(() {
      _page = 1;
    });
    String query = _searchController.text.trim();
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

    try {
      BookResult result = await widget.bookService.search(request);
      setState(() {
        _isEnd = result.metadata.isEnd;
      });

      setState(() {
        _books = result.books;
        _isLoading = false;
      });
    } on Exception {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }
      SnackbarUtil.showError(context, "예외가 발생했습니다. 다시 시도해 주세요.");
    }
  }

  /// 스크롤 끝까지 도달 시 추가 도서 검색
  Future<void> findMoreBooks() async {
    setState(() {
      _isLoadingMore = true;
      ++_page;
    });
    String query = _searchController.text.trim();

    BookRequest request = BookRequest(
      query: query,
      sortType: _sortType,
      page: _page,
      size: _size,
      searchType: _searchType,
    );

    try {
      BookResult result = await widget.bookService.search(request);
      setState(() {
        _isEnd = result.metadata.isEnd;
      });

      setState(() {
        _books.addAll(result.books);
        _isLoadingMore = false;
      });
    } on Exception {
      setState(() {
        _isLoadingMore = false;
      });
      if (!mounted) {
        return;
      }
      SnackbarUtil.showError(context, "예외가 발생했습니다.");
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "도서 검색"),
      floatingActionButton: _showScrollToTop
          ? ScrollFloatingAction(onPressed: _scrollToTop)
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: ListView.builder(
                    controller: _scrollController,
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
          if (_isLoadingMore)
            Padding(
              padding: EdgeInsetsGeometry.only(top: 10.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
