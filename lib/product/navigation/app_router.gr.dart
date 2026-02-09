// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:birthday_reminder/feature/auth/view/auth_wrapper_view.dart'
    as _i1;
import 'package:birthday_reminder/feature/auth/view/login_view.dart' as _i4;
import 'package:birthday_reminder/feature/auth/view/register_view.dart' as _i5;
import 'package:birthday_reminder/feature/birthday/view/birthday_form_view.dart'
    as _i2;
import 'package:birthday_reminder/feature/home/view/home_view.dart' as _i3;
import 'package:birthday_reminder/product/models/birthday_model.dart' as _i8;
import 'package:flutter/material.dart' as _i7;

/// generated route for
/// [_i1.AuthWrapperView]
class AuthWrapperRoute extends _i6.PageRouteInfo<void> {
  const AuthWrapperRoute({List<_i6.PageRouteInfo>? children})
      : super(
          AuthWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthWrapperRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthWrapperView();
    },
  );
}

/// generated route for
/// [_i2.BirthdayFormView]
class BirthdayFormRoute extends _i6.PageRouteInfo<BirthdayFormRouteArgs> {
  BirthdayFormRoute({
    _i7.Key? key,
    _i8.BirthdayModel? birthday,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          BirthdayFormRoute.name,
          args: BirthdayFormRouteArgs(
            key: key,
            birthday: birthday,
          ),
          initialChildren: children,
        );

  static const String name = 'BirthdayFormRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BirthdayFormRouteArgs>(
          orElse: () => const BirthdayFormRouteArgs());
      return _i2.BirthdayFormView(
        key: args.key,
        birthday: args.birthday,
      );
    },
  );
}

class BirthdayFormRouteArgs {
  const BirthdayFormRouteArgs({
    this.key,
    this.birthday,
  });

  final _i7.Key? key;

  final _i8.BirthdayModel? birthday;

  @override
  String toString() {
    return 'BirthdayFormRouteArgs{key: $key, birthday: $birthday}';
  }
}

/// generated route for
/// [_i3.HomeView]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomeView();
    },
  );
}

/// generated route for
/// [_i4.LoginView]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginView();
    },
  );
}

/// generated route for
/// [_i5.RegisterView]
class RegisterRoute extends _i6.PageRouteInfo<void> {
  const RegisterRoute({List<_i6.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.RegisterView();
    },
  );
}
