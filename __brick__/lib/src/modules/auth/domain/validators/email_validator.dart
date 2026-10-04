class EmailValidator {
  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+\-]+@(?:[A-Za-z0-9\-]+\.)+[A-Za-z]{2,}$',
  );

  String? call(String? email) {
    if (email == null || !_emailRegex.hasMatch(email.trim())) {
      return 'Enter a valid email.';
    }

    return null;
  }
}
