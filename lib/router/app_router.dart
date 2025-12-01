import 'package:go_router/go_router.dart';
import 'package:rebook/pages/book/book_details_page.dart';
import 'package:rebook/pages/book/book_search_page.dart';
import 'package:rebook/pages/auth/login_page.dart';
import 'package:rebook/pages/main_page.dart';
import 'package:rebook/pages/auth/signup_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(path: "/", builder: (_, __) => const MainPage()),
      GoRoute(path: "/login", builder: (_, __) => const LoginPage()),
      GoRoute(path: "/signup", builder: (_, __) => SignupPage()),
      GoRoute(path: "/book/search", builder: (_, __) => BookSearchPage()),
      GoRoute(
        path: "/book/:isbn",
        builder: (_, state) {
          final isbn = state.pathParameters['isbn'];
          return BookDetailsPage(isbn: isbn!);
        },
      ),
    ],
  );
}
