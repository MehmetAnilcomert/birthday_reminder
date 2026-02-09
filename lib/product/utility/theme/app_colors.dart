import 'package:flutter/material.dart';

@immutable
final class AppColors {
  const AppColors._();

  // Primary Birthday Theme Colors
  static const Color primary = Color(0xFFE91E63); // Pink
  static const Color primaryLight = Color(0xFFF48FB1);
  static const Color primaryDark = Color(0xFFC2185B);

  // Secondary Colors
  static const Color secondary = Color(0xFF2196F3); // Blue
  static const Color secondaryLight = Color(0xFF64B5F6);
  static const Color secondaryDark = Color(0xFF1976D2);

  // Accent Colors
  static const Color accent = Color(0xFFFF4081);
  static const Color accentLight = Color(0xFFFF80AB);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Divider & Border
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);

  // Special Birthday Colors
  static const Color birthdayToday = Color(0xFFFF1744);
  static const Color birthdayUpcoming = Color(0xFFFF6E40);
  static const Color birthdayPast = Color(0xFF9E9E9E);
}

