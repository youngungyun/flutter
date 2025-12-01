import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
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

  Future<BookResult> search(BookRequest request) async {
    final String query = request.query;
    final String sort = request.sortType.label;
    final String page = request.page.toString();
    final String size = request.size.toString();
    final String target = request.searchType.label;

    final url = Uri.parse(
      '$base?query=$query&sort=$sort&page=$page&size=$size&target=$target',
    );

    _logger.i("request: $url");

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

    _logger.i("response to $query");

    return BookResult(books: books, metadata: metadata);
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
