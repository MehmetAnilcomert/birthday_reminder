import 'package:birthday_reminder/product/init/theme/custom_theme.dart';
import 'package:flutter/material.dart';

/// Creates a light color scheme.
final class LightColorScheme extends CustomTheme {
  /// Creates a light color scheme.
  LightColorScheme(super.textTheme);

  /// Returns the light color scheme used in the application.
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFB71C1C),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFFDAD6),
      onPrimaryContainer: Color(0xFF410002),
      secondary: Color(0xFF775652),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFFDAD6),
      onSecondaryContainer: Color(0xFF2C1512),
      tertiary: Color(0xFF705C2E),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFDDFA6),
      onTertiaryContainer: Color(0xFF261A00),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
      onError: Color(0xFFFFFFFF),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFFFFBFF),
      onSurface: Color(0xFF201A19),
      surfaceContainerHighest: Color(0xFFF5DDDA),
      onSurfaceVariant: Color(0xFF534341),
      outline: Color(0xFF857371),
      onInverseSurface: Color(0xFFFBEEEC),
      inverseSurface: Color(0xFF362F2E),
      inversePrimary: Color(0xFFFFB4AB),
      shadow: Color(0xFF000000),
      surfaceTint: Color(0xFFB71C1C),
      outlineVariant: Color(0xFFD8C2BF),
      scrim: Color(0xFF000000),
    );
  }

  /// Creates a light theme data with using the light color scheme and
  /// superclass theme method.
  ThemeData light() {
    return theme(lightScheme());
  }
}
