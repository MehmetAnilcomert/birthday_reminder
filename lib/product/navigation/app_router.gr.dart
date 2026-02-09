// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:birthday_reminder/feature/auth/view/login_view.dart' as _i3;
import 'package:birthday_reminder/feature/auth/view/register_view.dart' as _i4;
import 'package:birthday_reminder/feature/birthday/view/birthday_form_view.dart'
    as _i1;
import 'package:birthday_reminder/feature/home/view/home_view.dart' as _i2;
import 'package:birthday_reminder/product/models/birthday_model.dart' as _i7;
import 'package:flutter/material.dart' as _i6;

/// generated route for
/// [_i1.BirthdayFormView]
class BirthdayFormRoute extends _i5.PageRouteInfo<BirthdayFormRouteArgs> {
  BirthdayFormRoute({
    _i6.Key? key,
    _i7.BirthdayModel? birthday,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          BirthdayFormRoute.name,
          args: BirthdayFormRouteArgs(
            key: key,
            birthday: birthday,
          ),
          initialChildren: children,
        );

  static const String name = 'BirthdayFormRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BirthdayFormRouteArgs>(
          orElse: () => const BirthdayFormRouteArgs());
      return _i1.BirthdayFormView(
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

  final _i6.Key? key;

  final _i7.BirthdayModel? birthday;

  @override
  String toString() {
    return 'BirthdayFormRouteArgs{key: $key, birthday: $birthday}';
  }
}

/// generated route for
/// [_i2.HomeView]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeView();
    },
  );
}

/// generated route for
/// [_i3.LoginView]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute({List<_i5.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginView();
    },
  );
}

/// generated route for
/// [_i4.RegisterView]
class RegisterRoute extends _i5.PageRouteInfo<void> {
  const RegisterRoute({List<_i5.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.RegisterView();
    },
  );
}
