import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:rebook/dto/book/book_details.dart';
import 'package:rebook/dto/review/review_response.dart';
import 'package:rebook/services/book_service.dart';
import 'package:rebook/dto/review/review_write_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var _logger = Logger();

class ReviewService {
  static final ReviewService instance = ReviewService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  final String base = 'https://dapi.kakao.com/v3/search/book';

  final String apiKey = dotenv.env['KAKAO_API_KEY'] ?? '';

  ReviewService._internal();

  /// isbn으로 리뷰, 작성자 닉네임, book_id 가져옴
  Future<List<ReviewResponse>> findReviews(String isbn) async {
    _logger.i('Find review: ISBN=$isbn');
    final response = await _supabase
        .from('review')
        .select('*, book!inner(isbn), profile(nickname)')
        .eq('book.isbn', isbn)
        .order('created_at', ascending: false);

    return response.map((review) {
      return ReviewResponse.fromJson(review);
    }).toList();
  }

  /// 도서 상제 정보로 upsert하고 book_id 구함
  /// 구한 book_id 이용하여 리뷰 insert
  Future<WriteReviewResult> writeReview(
    BookDetails book,
    ReviewWriteRequest request,
  ) async {
    final BookService bookService = BookService.instance;
    try {
      final String bookId = await bookService.insertBook(book);

      await _supabase.from('review').insert({
        'user_id': request.userId,
        'book_id': bookId,
        'title': request.title,
        'contents': request.contents,
        'rating': request.rating,
      });
      return WriteReviewResult.success;
    } on AuthException catch (e) {
      _logger.e("Write review error: ${e.message}");
      return WriteReviewResult.failure;
    }
  }
}

enum WriteReviewResult { success, failure }
