import 'package:logger/logger.dart';
import 'package:rebook/exceptions/registered_email_exception.dart';
import 'package:rebook/dto/auth/login_request.dart';
import 'package:rebook/dto/auth/signup_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var _logger = Logger();

/// 유저 정보 관련 서비스 클래스
class AuthService {
  static final AuthService instance = AuthService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  AuthService._internal();

  /// 회원가입 메서드
  /// [request]: 회원가입 요청 DTO
  /// Throws:
  /// * [RegisteredEmailException]: 이미 가입된 이메일
  /// * [AuthException]: 유효성 혹은 DB 관련 예외 발생
  Future<void> signup(SignupRequest request) async {
    final String email = request.email;
    final String nickname = request.nickname;
    final String password = request.password;

    try {
      await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {"nickname": nickname},
      );
    } on AuthException catch (e) {
      _logger.e(e);

      // 이미 존재하는 이메일
      if (e.statusCode == '422') {
        throw RegisteredEmailException(e.message);
      }
      rethrow;
    }
  }

  /// 로그인 메서드
  /// [request]: 로그인 요청 DTO
  /// Throws:
  /// * [AuthException]: 일치하는 이메일이 없거나 비밀번호가 일치하지 않음. 혹은 DB 관련 예외
  Future<void> login(LoginRequest request) async {
    _logger.i("login request: $request.email");
    try {
      await _supabase.auth.signInWithPassword(
        email: request.email,
        password: request.password,
      );
    } on AuthException {
      rethrow;
    }
  }

  /// 회원가입 전 닉네임의 존재 여부 확인
  /// [nickname]: 가입하려는 이메일
  /// Returns:
  /// * 해당 닉네임을 사용 가능하면 true
  /// * 이미 존재하는 닉네임이면 false
  Future<bool> isNicknameAvailable(String nickname) async {
    try {
      final int response = await _supabase
          .from('profile')
          .count()
          .eq('nickname', nickname)
          .timeout(const Duration(seconds: 10));
      return response == 0;
    } on Exception catch (e) {
      _logger.e(e);
      rethrow;
    }
  }
}
