class EmailValidator {
  String? call(String? email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (!emailRegex.hasMatch(email.toString())) {
      return 'Enter a valid email.';
    }

    return null;
  }
}
