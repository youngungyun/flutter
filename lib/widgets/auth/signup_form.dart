import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebook/exceptions/registered_email_exception.dart';
import 'package:rebook/dto/auth/signup_request.dart';
import 'package:rebook/services/auth_service.dart';
import 'package:rebook/utils/snackbar_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupForm extends StatefulWidget {
  final AuthService authService = AuthService.instance;
  final _formKey = GlobalKey<FormState>();

  SignupForm({super.key});

  @override
  State<StatefulWidget> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final passwordController = TextEditingController();
  late final AuthService _authService;
  late final GlobalKey<FormState> _formKey;
  String _email = '';
  String _nickname = '';
  String _password = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService;
    _formKey = widget._formKey;
  }

  // TODO: 부모 위젯에서 콜백 형식으로 처리. 폼(UI)과 로직 모듈 분리
  Future<void> submit() async {
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

    try {
      final isAvailable = await _authService.isNicknameAvailable(_nickname);
      if (!isAvailable) {
        SnackbarUtil.showError(context, "이미 존재하는 닉네임입니다.");
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } on Exception {
      setState(() {
        _isLoading = false;
      });
      SnackbarUtil.showError(context, "예외 발생. 다시 시도해주세요.");
    }

    final SignupRequest request = SignupRequest(
      email: _email,
      nickname: _nickname,
      password: _password,
    );
    try {
      await _authService.signup(request);
      if (!mounted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      context.pop();
      SnackbarUtil.showSuccess(context, "회원가입이 완료되었습니다.");
    } on RegisteredEmailException {
      SnackbarUtil.showError(context, "이미 존재하는 이메일입니다.");
    } on AuthApiException {
      SnackbarUtil.showError(context, "예외가 발생했습니다. 다시 시도해 주세요.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // TODO: TextFormFiled 모듈화
  @override
  Widget build(BuildContext context) {
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    final TextStyle errorStyle = TextStyle(
      color: Theme.of(context).colorScheme.error,
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(flex: 2),
          TextFormField(
            style: TextStyle(color: onSurface),
            decoration: InputDecoration(
              labelText: '이메일',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: "example@example.com",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: errorStyle,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: SignupValidator.validateEmail,
            textInputAction: TextInputAction.next,
            onSaved: (value) {
              _email = value ?? '';
            },
          ),
          Spacer(flex: 1),

          TextFormField(
            style: TextStyle(color: onSurface),
            decoration: InputDecoration(
              labelText: '닉네임',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: "3~16자 이내로 입력",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: errorStyle,
            ),
            keyboardType: TextInputType.text,
            validator: SignupValidator.validateNickname,
            textInputAction: TextInputAction.next,
            onSaved: (value) {
              _nickname = value ?? '';
            },
          ),
          Spacer(flex: 1),

          TextFormField(
            controller: passwordController,
            style: TextStyle(color: onSurface),
            decoration: InputDecoration(
              labelText: '비밀번호',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: "8~16자 이내로 입력",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: errorStyle,
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            validator: SignupValidator.validatePassword,
            textInputAction: TextInputAction.next,
            onSaved: (value) {
              _password = value ?? '';
            },
          ),
          Spacer(flex: 1),

          TextFormField(
            style: TextStyle(color: onSurface),
            decoration: InputDecoration(
              labelText: '비밀번호 확인',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: "비밀번호 다시 입력",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: errorStyle,
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            validator: (value) => SignupValidator.validateRepeatPassword(
              value,
              passwordController.text,
            ),
            textInputAction: TextInputAction.next,
          ),
          Spacer(flex: 1),

          ElevatedButton(
            onPressed: _isLoading ? null : submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: _isLoading
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : Text(
                    "회원가입",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class SignupValidator {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "이메일을 입력하세요.";
    }
    if (!EmailValidator.validate(email)) {
      return "올바른 이메일 양식이 아닙니다.";
    }
    return null;
  }

  static String? validateNickname(String? nickname) {
    if (nickname == null || nickname.isEmpty) {
      return "닉네임을 입력하세요.";
    }
    if (nickname.length < 3) {
      return "닉네임이 너무 짧습니다.";
    }
    if (nickname.length > 16) {
      return "닉네임이 너무 깁니다.";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "비밀번호를 입력하세요.";
    }
    if (password.length < 8) {
      return "비밀번호가 너무 짧습니다.";
    }
    if (password.length > 16) {
      return "비밀번호가 너무 깁니다.";
    }
    return null;
  }

  static String? validateRepeatPassword(String? repeat, String origin) {
    if (repeat != origin) {
      return "비밀번호가 일치하지 않습니다.";
    }
    return null;
  }
}
