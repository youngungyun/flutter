import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebook/dto/book/book_details.dart';
import 'package:rebook/dto/review/review_response.dart';
import 'package:rebook/services/book_service.dart';
import 'package:rebook/services/review_service.dart';
import 'package:rebook/utils/snackbar_util.dart';
import 'package:rebook/widgets/book/book_details_card.dart';
import 'package:rebook/widgets/book/book_details_card_skeleton.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';
import 'package:rebook/widgets/review/review_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookDetailsScreen extends StatefulWidget {
  final String isbn;

  const BookDetailsScreen({super.key, required this.isbn});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  final BookService bookService = BookService.instance;
  final ReviewService reviewService = ReviewService.instance;
  late Future<BookDetails> _bookDetailsFuture;
  late Future<List<ReviewResponse>> _reviewListFuture;
  bool _isBookLoading = true;
  bool _isReviewListLoading = true;

  @override
  void initState() {
    super.initState();
    _bookDetailsFuture = bookService.getDetails(widget.isbn)
      ..then(
        (_) => setState(() {
          _isBookLoading = false;
        }),
      );
    _reviewListFuture = reviewService.findReviews(widget.isbn)
      ..then(
        (_) => setState(() {
          _isReviewListLoading = false;
        }),
      );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onReviewButtonPressed() {
      // 로그인 중이 아니면 로그인 페이지로 리다이렉트
      if (Supabase.instance.client.auth.currentSession == null) {
        SnackbarUtil.showError(context, '로그인이 필요한 서비스입니다.');
        context.push("/login");
      } else {
        // 로그인 중이면 리뷰 작성페이지로 이동
        context.push("/review/write", extra: widget.isbn);
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "도서 상세",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              // TODO: 클릭시 읽은 책 저장 혹은 삭제 구현 및 아이콘 변경하기
              onPressed: () {},
              icon: Icon(Icons.circle_outlined),
              iconSize: 35.0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<BookDetails>(
              future: _bookDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BookDetailsCardSkeleton();
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text(
                      "다시 시도해주세요.",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                BookDetails result = snapshot.data!;

                return BookDetailsCard(bookDetails: result);
              },
            ),
            ElevatedButton(
              onPressed: (_isBookLoading || _isReviewListLoading)
                  ? null
                  : onReviewButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: (_isBookLoading || _isReviewListLoading)
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Text("리뷰 작성하기", style: TextStyle(fontSize: 18.0)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
              child: Text(
                '리뷰 목록',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<ReviewResponse>>(
              future: _reviewListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text(
                      "리뷰를 가져올 수 없습니다.",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                List<ReviewResponse> reviews = snapshot.data!;
                if (reviews.isEmpty) {
                  return Text("리뷰가 없습니다!", style: TextStyle(fontSize: 16));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: reviews.length,
                  itemBuilder: (context, index) =>
                      ReviewCard(key: ValueKey(index), review: reviews[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
