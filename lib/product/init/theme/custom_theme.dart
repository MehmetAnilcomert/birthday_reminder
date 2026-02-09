import 'package:flutter/material.dart';

/// Abstract class representing a custom theme for the application.
abstract class CustomTheme {
  /// Creates an instance of [CustomTheme] with the given [textTheme].
  const CustomTheme(this.textTheme);

  /// The text theme used in the custom theme.
  final TextTheme textTheme;

  /// Generates a [ThemeData] based on the provided [colorScheme].
  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );
}
