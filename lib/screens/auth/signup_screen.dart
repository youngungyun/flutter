import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebook/utils/snackbar_util.dart';
import 'package:rebook/widgets/auth/signup_form.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  void onSuccess(BuildContext context, String message) {
    context.pop();
    SnackbarUtil.showSuccess(context, message);
  }

  void onError(BuildContext context, String message) {
    SnackbarUtil.showError(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "회원가입"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SignupForm(onSuccess: onSuccess, onError: onError),
      ),
    );
  }
}
