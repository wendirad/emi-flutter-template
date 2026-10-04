class TextValidator {
  String? call(String? text, {String? field}) {
    if (text!.isEmpty) {
      return 'Enter a valid ${(field ?? "value")}.';
    }
    return null;
  }
}
