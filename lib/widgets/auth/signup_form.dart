import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:rebook/dto/auth/signup_request.dart';
import 'package:rebook/services/auth_service.dart';

class SignupForm extends StatefulWidget {
  final AuthService authService = AuthService.instance;
  final _formKey = GlobalKey<FormState>();

  final Function(BuildContext, String) _onSuccess;
  final Function(BuildContext, String) _onError;

  SignupForm({
    super.key,
    required void Function(BuildContext, String) onSuccess,
    required void Function(BuildContext, String) onError,
  }) : _onError = onError,
       _onSuccess = onSuccess;

  @override
  State<StatefulWidget> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _passwordController = TextEditingController();
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

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

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

    final SignupRequest request = SignupRequest(
      email: _email,
      nickname: _nickname,
      password: _password,
    );

    SignupResult result = await _authService.signup(request);
    setState(() {
      _isLoading = false;
    });
    if (!mounted) {
      return;
    }

    switch (result) {
      case SignupResult.success:
        widget._onSuccess(context, "회원가입이 완료되었습니다.");
        break;
      case SignupResult.duplicateNickname:
        widget._onError(context, "이미 존재하는 닉네임입니다.");
        break;
      case SignupResult.duplicateEmail:
        widget._onError(context, "이미 가입된 이메일입니다.");
        break;
      case SignupResult.error:
        widget._onError(context, "예외가 발생했습니다. 다시 시도해 주세요.");
        break;
    }
  }

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
            textCapitalization: TextCapitalization.none,
          ),
          Spacer(flex: 1),

          TextFormField(
            controller: _passwordController,
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
            textCapitalization: TextCapitalization.none,
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
              _passwordController.text,
            ),
            textInputAction: TextInputAction.go,
            textCapitalization: TextCapitalization.none,
          ),
          Spacer(flex: 1),

          ElevatedButton(
            onPressed: _isLoading ? null : submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: _isLoading
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : Text("회원가입", style: TextStyle(fontSize: 16)),
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
