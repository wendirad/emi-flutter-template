class ConfirmPasswordValidator {
  String? call(String? confirmPassowrd, String? password) {
    if (confirmPassowrd == null || confirmPassowrd.isEmpty) {
      return 'Please confirm your password';
    }
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (confirmPassowrd != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
