import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final storage = FlutterSecureStorage();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoggedIn = Supabase.instance.client.auth.currentSession != null;
  String _nickname =
      Supabase.instance.client.auth.currentUser?.userMetadata?['nickname'];

  /// 로그아웃 메서드
  /// 로컬에서 세션 삭제 후 flag 변경
  Future<void> _logout(BuildContext context) async {
    Supabase.instance.client.auth.signOut(scope: SignOutScope.local);

    if (!mounted) {
      return;
    }

    _refreshLoginState();
  }

  void _refreshLoginState() {
    setState(() {
      _isLoggedIn = Supabase.instance.client.auth.currentSession != null;
      _nickname =
          Supabase.instance.client.auth.currentUser?.userMetadata?['nickname'];
    });
  }

  // TODO: 로그인 상태 위젯과 비로그인 상태 위젯 분리
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

            Text(
              'ReBook',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              '도서 리뷰를 한 번에',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            Spacer(flex: 1),

            // 로그인 상태
            if (_isLoggedIn) ...[
              Text(
                _nickname,
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              TextButton(
                // TODO: 내가 읽은 책 목록 페이지 구현
                onPressed: () {},
                child: Text(
                  '내가 읽은 책',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Spacer(flex: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      // TODO: 회원 정보 수정 페이지 이동 구현
                      onPressed: () {},
                      child: Text(
                        '회원 정보 수정',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _logout(context),
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

              // 비 로그인 상태
            ] else ...[
              TextButton(
                onPressed: () async {
                  context.push("/login");
                  _refreshLoginState();
                },
                child: Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(height: 8),

              TextButton(
                onPressed: () async {
                  await context.push("/signup");
                  _refreshLoginState();
                },
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),

              Spacer(flex: 4),
            ],
          ],
        ),
      ),
    );
  }
}
