import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rebook/router/app_router.dart';
import 'package:rebook/themes/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.get("PROJECT_URL"),
    anonKey: dotenv.get("PROJECT_API_KEY"),
  );
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
