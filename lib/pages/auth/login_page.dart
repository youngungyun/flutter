import 'package:flutter/material.dart';
import 'package:rebook/widgets/auth/login_form.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "로그인"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: LoginForm(),
      ),
    );
  }
}
