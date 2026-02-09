import 'package:birthday_reminder/product/init/theme/dark_theme/dark_color_scheme.dart';
import 'package:flutter/material.dart';

/// The custom dark theme class.
final class CustomDarkTheme {
  /// The constructor for the custom dark theme.
  CustomDarkTheme() {
    themeData = ThemeData(
      useMaterial3: true,
      colorScheme: DarkColorScheme.darkScheme(),
    );
  }

  /// The dark theme data.
  late final ThemeData themeData;
}
