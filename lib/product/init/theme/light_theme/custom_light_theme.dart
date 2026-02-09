import 'package:birthday_reminder/product/init/theme/light_theme/light_color_scheme.dart';
import 'package:flutter/material.dart';

/// The custom light theme class.
final class CustomLightTheme {
  /// The constructor for the custom light theme.
  CustomLightTheme() {
    themeData = ThemeData(
      useMaterial3: true,
      colorScheme: LightColorScheme.lightScheme(),
    );
  }

  /// The light theme data.
  late final ThemeData themeData;
}
