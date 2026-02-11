import 'package:birthday_reminder/feature/auth/view/login_view.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:birthday_reminder/product/state/base/base_state.dart';
import 'package:birthday_reminder/product/utility/mixin/error_translator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin LoginViewMixin on BaseState<LoginView>, ErrorTranslator {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleObscurePassword() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      context.read<AuthViewModel>().signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    }
  }
}
