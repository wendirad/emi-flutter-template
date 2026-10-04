class TextValidator {
  String? call(String? text, {String? field}) {
    if (text == null || text.trim().isEmpty) {
      return 'Enter a valid ${(field ?? "value")}.';
    }
    return null;
  }
}
