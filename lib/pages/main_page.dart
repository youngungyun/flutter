import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

final storage = FlutterSecureStorage();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // TODO: 로그인 여부에 따라 다른 위젯 보여주기 구현

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.push("/book/search");
            },
            icon: Icon(Icons.search),
            iconSize: 48,
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(flex: 2),

            // TODO: 로그인 시 위젯 구현 후 위젯으로 분리하기
            Text(
              'ReBook',
              style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
            ),
            Text('도서 리뷰를 한 번에', style: TextStyle(fontSize: 18)),

            Spacer(flex: 1),

            TextButton(
              onPressed: () {
                context.push("/login");
              },
              child: Text(
                '로그인',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.primary,
                  decorationThickness: 2,
                ),
              ),
            ),

            SizedBox(height: 8),

            TextButton(
              onPressed: () {
                context.push("/signup");
              },
              child: Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.primary,
                  decorationThickness: 2,
                ),
              ),
            ),

            Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
