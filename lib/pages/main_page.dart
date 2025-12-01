import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:rebook/widgets/common/logged_in_widget.dart';
import 'package:rebook/widgets/common/logged_out_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final storage = FlutterSecureStorage();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoggedIn = false;
  String _nickname = '';

  @override
  void initState() {
    super.initState();
    _refreshLoginState();
  }

  Future<void> _onLogin() async {
    await context.push("/login");
    _refreshLoginState();
  }

  Future<void> _onSignup() async {
    await context.push("/signup");
    _refreshLoginState();
  }

  Future<void> _onLogout() async {
    Supabase.instance.client.auth.signOut(scope: SignOutScope.local);

    if (!mounted) {
      return;
    }

    _refreshLoginState();
  }

  void _refreshLoginState() {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoggedIn = Supabase.instance.client.auth.currentSession != null;
      _nickname =
          Supabase
              .instance
              .client
              .auth
              .currentUser
              ?.userMetadata?['nickname'] ??
          '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              onPressed: () {
                context.push("/book/search");
              },
              icon: Icon(Icons.search),
              iconSize: 48,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 120),
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

            // 로그인 상태
            if (_isLoggedIn) ...[
              LoggedInWidget(nickname: _nickname, onLogout: _onLogout),
              // 비 로그인 상태
            ] else ...[
              LoggedOutWidget(onLogin: _onLogin, onSignup: _onSignup),
            ],
          ],
        ),
      ),
    );
  }
}
