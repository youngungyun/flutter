import 'package:go_router/go_router.dart';
import 'package:rebook/screens/book/book_details_screen.dart';
import 'package:rebook/screens/book/book_search_screen.dart';
import 'package:rebook/screens/auth/login_screen.dart';
import 'package:rebook/screens/main_screen.dart';
import 'package:rebook/screens/auth/signup_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(path: "/", builder: (_, __) => const MainScreen()),
      GoRoute(path: "/login", builder: (_, __) => const LoginScreen()),
      GoRoute(path: "/signup", builder: (_, __) => SignupScreen()),
      GoRoute(path: "/book/search", builder: (_, __) => BookSearchScreen()),
      GoRoute(
        path: "/book/:isbn",
        builder: (_, state) {
          final isbn = state.pathParameters['isbn'];
          return BookDetailsScreen(isbn: isbn!);
        },
      ),
    ],
  );
}
