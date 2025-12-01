import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebook/dto/auth/login_request.dart';
import 'package:rebook/services/auth_service.dart';
import 'package:rebook/utils/snackbar_util.dart';
import 'package:supabase/supabase.dart';

class LoginForm extends StatefulWidget {
  final AuthService authService = AuthService.instance;
  final _formKey = GlobalKey<FormState>();

  LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final AuthService _authService;
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService;
  }

  // TODO: 부모 위젯에서 콜백 형식으로 처리. 폼(UI)과 로직 모듈 분리
  Future<void> submit() async {
    setState(() {
      _isLoading = true;
    });
    widget._formKey.currentState!.save();

    final LoginRequest request = LoginRequest(
      email: _email,
      password: _password,
    );

    try {
      await _authService.login(request);
      if (!mounted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      context.pop();
      SnackbarUtil.showSuccess(context, "로그인이 완료되었습니다.");
    } on AuthException {
      SnackbarUtil.showError(context, "이메일 또는 비밀번호가 잘못되었습니다.");
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
      key: widget._formKey,
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
            textInputAction: TextInputAction.next,
            onSaved: (value) {
              _email = value ?? '';
            },
          ),
          Spacer(flex: 1),
          TextFormField(
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
            textInputAction: TextInputAction.next,

            onSaved: (value) {
              _password = value ?? '';
            },
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
                    "로그인",
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
