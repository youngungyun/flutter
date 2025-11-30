import 'package:logger/logger.dart';
import 'package:rebook/exceptions/registered_email_exception.dart';
import 'package:rebook/models/auth/login_request.dart';
import 'package:rebook/models/auth/signup_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var _logger = Logger();

class AuthService {
  static final AuthService instance = AuthService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  AuthService._internal();

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
