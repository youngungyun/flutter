class RegisteredEmailException implements Exception {
  final String message;

  RegisteredEmailException(this.message);

  @override
  String toString() => message;
}
