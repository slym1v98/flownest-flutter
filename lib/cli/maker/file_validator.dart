class FileValidator {
  static bool isValid(String fileName) {
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    return regex.hasMatch(fileName);
  }
}
