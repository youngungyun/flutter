import 'package:flutter/material.dart';
import 'package:rebook/dto/auth/login_request.dart';
import 'package:rebook/services/auth_service.dart';

class LoginForm extends StatefulWidget {
  final AuthService authService = AuthService.instance;
  final _formKey = GlobalKey<FormState>();

  final Function(BuildContext, String) _onSuccess;
  final Function(BuildContext, String) _onError;

  LoginForm({
    super.key,
    required dynamic Function(BuildContext, String) onSuccess,
    required dynamic Function(BuildContext, String) onError,
  }) : _onError = onError,
       _onSuccess = onSuccess;

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

  Future<void> submit() async {
    setState(() {
      _isLoading = true;
    });
    widget._formKey.currentState!.save();

    final LoginRequest request = LoginRequest(
      email: _email,
      password: _password,
    );

    LoginResult result = await _authService.login(request);
    setState(() {
      _isLoading = false;
    });
    if (!mounted) {
      return;
    }

    switch (result) {
      case LoginResult.success:
        widget._onSuccess(context, "로그인이 성공했습니다.");
        break;
      case LoginResult.failure:
        widget._onError(context, "이메일 또는 비밀번호가 일치하지 않습니다.");
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
            textInputAction: TextInputAction.go,

            onSaved: (value) {
              _password = value ?? '';
            },
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
                : Text("로그인", style: TextStyle(fontSize: 16)),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
