abstract final class RegistrationValidator {
  static String? validateFullName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Enter your full name';
    }
    if (RegExp(r'\d').hasMatch(trimmed)) {
      return 'Name cannot contain digits';
    }
    return null;
  }

  static String? validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Enter your email';
    }
    if (!trimmed.contains('@')) {
      return 'Email must contain @';
    }
    final basic = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!basic.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String password, String confirm) {
    if (password != confirm) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateOptionalNewPassword({
    required String newPassword,
    required String confirmNewPassword,
  }) {
    if (newPassword.isEmpty && confirmNewPassword.isEmpty) {
      return null;
    }
    if (newPassword.isEmpty || confirmNewPassword.isEmpty) {
      return 'Enter and confirm your new password';
    }
    final pwdErr = validatePassword(newPassword);
    if (pwdErr != null) {
      return pwdErr;
    }
    return validateConfirmPassword(newPassword, confirmNewPassword);
  }
}
