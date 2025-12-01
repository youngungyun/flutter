import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebook/utils/snackbar_util.dart';
import 'package:rebook/widgets/auth/login_form.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void onSuccess(BuildContext context, String message) {
    SnackbarUtil.showSuccess(context, message);
    context.pop();
  }

  void onError(BuildContext context, String message) {
    SnackbarUtil.showError(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "로그인"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: LoginForm(onSuccess: onSuccess, onError: onError),
      ),
    );
  }
}
