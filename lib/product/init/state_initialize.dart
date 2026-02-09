import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/state/view_model/product_view_model.dart';
import 'package:birthday_reminder/feature/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that initializes bloc state management for the application.
class StateInitialize extends StatelessWidget {
  /// Creates an instance of [StateInitialize] with the given [child].
  const StateInitialize({required this.child, super.key});

  /// The child widget to be wrapped with state management providers.
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductViewModel>.value(
          value: ProductStateItems.productViewModel,
        ),
        BlocProvider<AuthViewModel>.value(
          value: ProductStateItems.authViewModel,
        ),
      ],
      child: child,
    );
  }
}
