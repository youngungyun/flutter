import 'package:flutter/material.dart';
import 'package:rebook/router/app_router.dart';
import 'package:rebook/themes/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "ReBook",
      routerConfig: AppRouter.router,
      theme: AppTheme.defaultTheme,
    );
  }
}
