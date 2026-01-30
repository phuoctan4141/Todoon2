class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'auth.notNullEmail';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'auth.notEmail';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.notNullPass';
    }

    if (RegExp(r'\s').hasMatch(value)) {
      return 'auth.space';
    }

    if (value.length < 8) {
      return 'auth.shortPass';
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'auth.notNullPass';
    }

    if (value != password) {
      return 'auth.passNotMatch';
    }

    return null;
  }
}
