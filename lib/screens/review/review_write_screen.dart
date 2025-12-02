import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebook/dto/book/book_details.dart';
import 'package:rebook/services/book_service.dart';
import 'package:rebook/utils/snackbar_util.dart';
import 'package:rebook/widgets/book/book_details_card.dart';
import 'package:rebook/widgets/book/book_details_card_skeleton.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';
import 'package:rebook/widgets/review/review_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewWriteScreen extends StatefulWidget {
  final String isbn;

  const ReviewWriteScreen({super.key, required this.isbn});

  @override
  State<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends State<ReviewWriteScreen> {
  final BookService bookService = BookService.instance;
  late final Future<BookDetails> _bookFuture;
  double rating = 3.0;

  @override
  void initState() {
    super.initState();
    _bookFuture = _fetchData();
  }

  Future<BookDetails> _fetchData() {
    return bookService.getDetails(widget.isbn);
  }

  void _onSuccess(BuildContext context, String message) {
    context.pop();
    SnackbarUtil.showSuccess(context, message);
  }

  void _onError(BuildContext context, String message) {
    SnackbarUtil.showError(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "리뷰 작성"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<BookDetails>(
              future: _bookFuture,
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
            FutureBuilder<BookDetails>(
              future: _bookFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
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

                return ReviewForm(
                  onSuccess: _onSuccess,
                  onError: _onError,
                  bookDetails: snapshot.data!,
                  userId: Supabase.instance.client.auth.currentUser?.id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
