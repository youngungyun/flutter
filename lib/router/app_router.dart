import 'package:go_router/go_router.dart';
import 'package:rebook/pages/main_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [GoRoute(path: "/", builder: (context, state) => const MainPage())],
  );
}
