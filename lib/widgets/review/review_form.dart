import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rebook/dto/book/book_details.dart';
import 'package:rebook/services/review_service.dart';
import 'package:rebook/dto/review/review_write_request.dart';

class ReviewForm extends StatefulWidget {
  final ReviewService _reviewService = ReviewService.instance;
  final _formKey = GlobalKey<FormState>();

  final void Function(BuildContext, String) _onSuccess;
  final void Function(BuildContext, String) _onError;
  final BookDetails _bookDetails;
  final String _userId;

  ReviewForm({
    super.key,
    required void Function(BuildContext, String) onSuccess,
    required void Function(BuildContext, String) onError,
    required bookDetails,
    required userId,
  }) : _onError = onError,
       _onSuccess = onSuccess,
       _bookDetails = bookDetails,
       _userId = userId;

  @override
  State<StatefulWidget> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  late final ReviewService _reviewService;
  late final GlobalKey<FormState> _formKey;
  double _rating = 0.0;
  String _title = '';
  String _contents = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _formKey = widget._formKey;
    _reviewService = widget._reviewService;
  }

  Future<void> submit() async {
    if (_rating == 0.0) {
      widget._onError(context, "평점을 선택해주세요.");
    }

    setState(() {
      _isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formKey.currentState!.save();

    final ReviewWriteRequest request = ReviewWriteRequest(
      userId: widget._userId,
      title: _title,
      contents: _contents,
      rating: _rating,
    );

    WriteReviewResult result = await _reviewService.writeReview(
      widget._bookDetails,
      request,
    );

    setState(() {
      _isLoading = false;
    });
    if (!mounted) {
      return;
    }

    switch (result) {
      case WriteReviewResult.success:
        widget._onSuccess(context, "리뷰가 작성되었습니다.");
        break;
      case WriteReviewResult.failure:
        widget._onError(context, "리뷰 작성에 실패했습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 5.0,
              ),
              child: Column(
                children: [
                  Text(
                    "$_rating / 5.0",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: 0.0,
                    minRating: 1.0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsetsGeometry.symmetric(horizontal: 5.0),
                    itemBuilder: (context, _) {
                      return Icon(Icons.star, color: Colors.amber);
                    },
                    onRatingUpdate: (value) => setState(() {
                      _rating = value;
                    }),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 10.0,
            ),
            child: TextFormField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              decoration: InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "제목을 입력하세요.",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              keyboardType: TextInputType.text,
              validator: ReviewValidator.validateTitle,
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                _title = value ?? '';
              },
              textCapitalization: TextCapitalization.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 10.0,
            ),
            child: TextFormField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              decoration: InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "내용을 입력하세요.",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              keyboardType: TextInputType.text,
              validator: ReviewValidator.validateContents,
              textInputAction: TextInputAction.send,
              onSaved: (value) {
                _contents = value ?? '';
              },
              textCapitalization: TextCapitalization.none,

              minLines: 10,
              maxLines: null,
            ),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.all(10.0),
              child: _isLoading
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Text("리뷰 작성", style: TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(height: 40.0),
        ],
      ),
    );
  }
}

class ReviewValidator {
  static String? validateTitle(String? title) {
    if (title == null || title.isEmpty) {
      return "제목을 입력해주세요.";
    }
    return null;
  }

  static String? validateContents(String? contents) {
    if (contents == null || contents.isEmpty) {
      return "내용을 입력해주세요.";
    }
    return null;
  }
}
