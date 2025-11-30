import 'package:flutter/material.dart';
import 'package:rebook/widgets/auth/signup_form.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "회원가입"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SignupForm(),
      ),
    );
  }
}
