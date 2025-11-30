/// 회원가입 중 이미 가입된 이메일이 있을 시 던지는 예외입니다.
class RegisteredEmailException implements Exception {
  final String message;

  RegisteredEmailException(this.message);

  @override
  String toString() => message;
}
