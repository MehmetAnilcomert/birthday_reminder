final class AppConstants {
  const AppConstants._();

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String birthdaysCollection = 'birthdays';

  // Cache Keys
  static const String userCacheKey = 'user_cache';
  static const String isLoggedInKey = 'is_logged_in';

  // Date Format
  static const String dateFormat = 'dd/MM/yyyy';

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 500);
}

