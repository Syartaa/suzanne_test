class SValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required ';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required ';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long. ';
    }
    if (value.contains(r'[0-9]')) {
      return 'Password must have at least one number. ';
    }
    if (value.contains(r'[!@#$%^&*(),.?":{}|<>]')) {
      return 'Password must have at least one special character. ';
    }

    return null;
  }
}
