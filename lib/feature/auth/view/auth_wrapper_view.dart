import 'package:auto_route/auto_route.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:birthday_reminder/feature/auth/view_model/state/auth_state.dart';
import 'package:birthday_reminder/product/navigation/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthWrapperView extends StatelessWidget {
  const AuthWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthViewModel, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AuthStatus.authenticated:
            // User is authenticated, show home
            return const AutoRouter();
          case AuthStatus.unauthenticated:
          case AuthStatus.error:
            // User is not authenticated, redirect to login
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.router.replace(const LoginRoute());
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
