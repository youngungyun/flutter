import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoggedOutWidget extends StatelessWidget {
  final Future<void> Function() _onLogin;
  final Future<void> Function() _onSignup;

  const LoggedOutWidget({super.key, required onLogin, required onSignup})
    : _onLogin = onLogin,
      _onSignup = onSignup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 120),
        TextButton(
          onPressed: _onLogin,
          child: Text(
            '로그인',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        TextButton(
          onPressed: _onSignup,
          child: Text(
            '회원가입',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
