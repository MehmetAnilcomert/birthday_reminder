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
}
