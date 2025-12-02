import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoggedInWidget extends StatelessWidget {
  final String _nickname;
  final Future<void> Function() _onLogout;

  const LoggedInWidget({super.key, required nickname, required onLogout})
    : _nickname = nickname,
      _onLogout = onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        SizedBox(height: 40),
        Text(
          _nickname,
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        TextButton(
          onPressed: () {
            context.push("/read-book");
          },
          child: Text(
            '내가 읽은 책',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizedBox(height: 280),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  context.push("/profile");
                },
                child: Text(
                  '회원 정보 수정',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: _onLogout,
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
