import 'package:birthday_reminder/product/init/theme/custom_theme.dart';
import 'package:flutter/material.dart';

/// A class representing the dark color scheme for the application.
final class DarkColorScheme extends CustomTheme {
  /// Creates an instance of [DarkColorScheme] with the given [textTheme].
  DarkColorScheme(super.textTheme);

  /// Returns the dark color scheme used in the application.
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdafbb0),
      surfaceTint: Color(0xffb1d18a),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffadcd86),
      onPrimaryContainer: Color(0xff050e00),
      secondary: Color(0xffe9f4d5),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbcc7a9),
      onSecondaryContainer: Color(0xff060d01),
      tertiary: Color(0xffc9f9f5),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff9cccc7),
      onTertiaryContainer: Color(0xff000e0d),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff12140e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeef2e2),
      outlineVariant: Color(0xffc1c4b6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e3d8),
      inversePrimary: Color(0xff364f17),
      primaryFixed: Color(0xffcdeda3),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffb1d18a),
      onPrimaryFixedVariant: Color(0xff081400),
      secondaryFixed: Color(0xffdce7c8),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbfcbad),
      onSecondaryFixedVariant: Color(0xff0b1403),
      tertiaryFixed: Color(0xffbcece7),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa0d0cb),
      onTertiaryFixedVariant: Color(0xff001413),
      surfaceDim: Color(0xff12140e),
      surfaceBright: Color(0xff4f5149),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1e201a),
      surfaceContainer: Color(0xff2f312a),
      surfaceContainerHigh: Color(0xff3a3c35),
      surfaceContainerHighest: Color(0xff454840),
    );
  }

  /// Returns the ThemeData for the dark theme.
  ThemeData dark() {
    return theme(darkScheme());
  }
}
