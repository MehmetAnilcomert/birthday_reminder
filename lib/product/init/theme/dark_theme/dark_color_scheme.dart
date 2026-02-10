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
      primary: Color(0xFFFFB4AB),
      onPrimary: Color(0xFF690005),
      primaryContainer: Color(0xFF93000A),
      onPrimaryContainer: Color(0xFFFFDAD6),
      secondary: Color(0xFFE7BDB8),
      onSecondary: Color(0xFF442926),
      secondaryContainer: Color(0xFF5D3F3C),
      onSecondaryContainer: Color(0xFFFFDAD6),
      tertiary: Color(0xFFE0C38C),
      onTertiary: Color(0xFF3F2D04),
      tertiaryContainer: Color(0xFF574419),
      onTertiaryContainer: Color(0xFFFDDFA6),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
      onError: Color(0xFF690005),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF201A19),
      onSurface: Color(0xFFEDE0DE),
      surfaceContainerHighest: Color(0xFF534341),
      onSurfaceVariant: Color(0xFFD8C2BF),
      outline: Color(0xFFA08C8A),
      onInverseSurface: Color(0xFF201A19),
      inverseSurface: Color(0xFFEDE0DE),
      inversePrimary: Color(0xFFB71C1C),
      shadow: Color(0xFF000000),
      surfaceTint: Color(0xFFFFB4AB),
      outlineVariant: Color(0xFF534341),
      scrim: Color(0xFF000000),
    );
  }

  /// Returns the ThemeData for the dark theme.
  ThemeData dark() {
    return theme(darkScheme());
  }
}
