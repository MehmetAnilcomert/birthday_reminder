final class Validators {
  const Validators._();

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'required_field';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'invalid_email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'required_field';
    }
    if (value.length < 6) {
      return 'weak_password';
    }
    return null;
  }

  static String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'required_field';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'required_field';
    }
    if (value != password) {
      return 'passwords_dont_match';
    }
    return null;
  }

  static String? birthdayValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'birthday_required';
    }

    // Try to parse the date
    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();

      // Check if birthday is in the future
      if (date.isAfter(now)) {
        return 'birthday_future';
      }

      // Check if birthday is too old (more than 120 years ago)
      final maxAge = DateTime(now.year - 120, now.month, now.day);
      if (date.isBefore(maxAge)) {
        return 'birthday_too_old';
      }

      return null;
    } catch (e) {
      return 'invalid_birthday';
    }
  }
}
