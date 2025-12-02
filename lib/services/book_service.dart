import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:rebook/dto/book/book_details.dart';
import 'package:rebook/dto/book/book_request.dart';
import 'package:rebook/dto/book/book_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var _logger = Logger();

/// 도서 정보 로직 처리 서비스
class BookService {
  static final BookService instance = BookService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  final String base = 'https://dapi.kakao.com/v3/search/book';

  final String apiKey = dotenv.env['KAKAO_API_KEY'] ?? '';

  BookService._internal();

  /// 도서 검색
  Future<BookResult> search(BookRequest request) async {
    final String query = request.query;
    final String sort = request.sortType.name;
    final String page = request.page.toString();
    final String size = request.size.toString();
    final String target = request.searchType.name;

    String completedUrl =
        '$base?query=$query&sort=$sort&page=$page&size=$size&target=$target';

    final url = Uri.parse(completedUrl);

    _logger.i(completedUrl);

    final response = await http.post(
      url,
      headers: {"Authorization": 'KakaoAK $apiKey'},
    );

    // 정상적인 응답 아님
    if (response.statusCode != 200) {
      _logger.w('Response: $response.statusCode: $response.reasonPhrase');
      throw HttpException("incorrect response");
    }

    Map<String, dynamic> json = jsonDecode(response.body);

    List<dynamic> documents = json['documents'];
    List<BookResponse> books = documents.map((b) {
      return BookResponse.fromJson(b as Map<String, dynamic>);
    }).toList();

    Metadata metadata = Metadata.fromJson(json['meta']);

    _logger.i("response to query: $query");

    return BookResult(books: books, metadata: metadata);
  }

  /// 먼저 DB에 해당 도서 레코드가 있는지 검색
  /// 없으면 카카오 API로 도서 정보 찾아옴
  Future<BookDetails> getDetails(String isbn) async {
    final String sort = SortType.accurcy.name;
    final String page = '1';
    final String size = '1';
    final String target = SearchType.isbn.name;
    final String query = isbn;

    // DB에 해당 도서 정보 있으면 그대로 리턴
    final BookDetails? bookDetaulsFromDB = await _findByIsbn(isbn);
    if (bookDetaulsFromDB != null) {
      return bookDetaulsFromDB;
    }
    // 없으면 카카오 API로 가져옴
    String completedUrl =
        '$base?query=$query&sort=$sort&page=$page&size=$size&target=$target';

    final url = Uri.parse(completedUrl);

    _logger.i(completedUrl);

    try {
      final response = await http.post(
        url,
        headers: {"Authorization": 'KakaoAK $apiKey'},
      );
      // 정상적인 응답 아님
      if (response.statusCode != 200) {
        _logger.w('Response: $response.statusCode: $response.reasonPhrase');
        throw HttpException("incorrect response");
      }

      Map<String, dynamic> json = jsonDecode(response.body);

      _logger.i("Find details of book: $query");

      return BookDetails.fromJson(json['documents'][0]);
    } on Exception catch (e) {
      _logger.e("Can't find book: ${e.toString()}");
      rethrow;
    }
  }

  Future<BookDetails?> _findByIsbn(String isbn) async {
    _logger.i("Find book details: $isbn");

    try {
      final response = await _supabase
          .from('book')
          .select()
          .eq('isbn', isbn)
          .maybeSingle();
      if (response == null) {
        return null;
      }
      return BookDetails.fromJson(response);
    } on AuthException catch (e) {
      _logger.e("Can't find by ISBN: ${e.message}");
      return null;
    }
  }

  Future<String> insertBook(BookDetails book) async {
    try {
      _logger.i("Insert book: ${book.title}");

      final response = await _supabase
          .from('book')
          .upsert({
            'title': book.title,
            'authors': book.authors,
            'translators': book.translators,
            'contents': book.contents,
            'isbn': book.isbn,
            'publisher': book.publisher,
            'datetime': book.datetime.toIso8601String(),
            'thumbnail': book.thumbnail,
          }, onConflict: 'isbn')
          .select('book_id')
          .single();

      return response['book_id'];
    } on AuthException catch (e) {
      _logger.e("Book insert error: ${e.message}");
      rethrow;
    }
  }
}

enum SearchType {
  title('제목'),
  person('인명'),
  publisher('출판사'),
  isbn('ISBN');

  final String label;

  const SearchType(this.label);
}

enum SortType {
  accurcy('정확도순'),
  latest('최신순');

  final String label;

  const SortType(this.label);
}
